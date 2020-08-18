require 'rails_helper'

RSpec.describe Scraper, type: :service do
  let(:pga_data) { File.read('spec/fixtures/limited_data/stats.html') }
  let(:service) { Scraper.new }

  before(:each) do
    allow(HTTParty).to receive(:get).and_return(pga_data)
    allow_any_instance_of(Scraper).to receive(:sleep)
  end

  describe '#scrape_for_all_tournaments' do
    context 'when tournaments were scraped recently' do
      before do
        create(
          :scrape_logger,
          :tournament,
          run_at: DateTime.current - 5.minutes,
        )
      end

      it 'does not make any requests' do
        service.scrape_for_all_tournaments

        expect(HTTParty).not_to have_received(:get)
      end

      it 'does not log a scrape' do
        expect { service.scrape_for_all_tournaments }.not_to change { ScrapeLogger.tournament.count }
      end
    end

    context 'when tournaments were not scraped recently' do
      it 'makes 1 request to the PGA site per year' do
        service.scrape_for_all_tournaments

        expect(HTTParty).to have_received(:get).exactly(Scraper::YEARS.length).times
      end

      it 'creates a Tournament for each tournament found' do
        expect { service.scrape_for_all_tournaments }
          .to change { Tournament.count }
          .from(0).to(26 * Scraper::YEARS.length)
      end

      it 'logs a scrape' do
        expect { service.scrape_for_new_tournaments }
          .to change { ScrapeLogger.tournament.count }
          .from(0).to(1)
      end
    end
  end

  describe '#scrape_for_new_tournaments' do
    context 'when tournaments were scraped recently' do
      before do
        create(
          :scrape_logger,
          :tournament,
          run_at: DateTime.current - 5.minutes,
        )
      end

      it 'does not make any requests' do
        service.scrape_for_new_tournaments

        expect(HTTParty).not_to have_received(:get)
      end

      it 'does not log a scrape' do
        expect { service.scrape_for_new_tournaments }.not_to change { ScrapeLogger.tournament.count }
      end
    end

    context 'when tournaments were not scraped recently' do
      it 'makes 1 request to the 2020 PGA site' do
        service.scrape_for_new_tournaments

        expect(HTTParty).to have_received(:get).exactly(1).times
        expect(HTTParty).to have_received(:get).with("https://www.pgatour.com/stats/stat.02674.y2020.eon.t033.html")
      end

      it 'creates a Tournament for each tournament found' do
        expect { service.scrape_for_new_tournaments }
          .to change { Tournament.count }
          .from(0).to(26)
      end

      it 'logs a scrape' do
        expect { service.scrape_for_new_tournaments }
          .to change { ScrapeLogger.tournament.count }
          .from(0).to(1)
      end
    end
  end

  describe '#scrape_data_from_all_tournaments' do
    before(:each) do
      allow(CorrelationCalculator).to receive(:calculate)
    end

    context 'when data was scraped recently' do
      before do
        create(
          :scrape_logger,
          :data,
          run_at: DateTime.current - 5.minutes,
        )
      end

      it 'does not make any requests' do
        service.scrape_data_from_all_tournaments

        expect(HTTParty).not_to have_received(:get)
      end

      it 'does not log a scrape' do
        expect { service.scrape_data_from_all_tournaments }.not_to change { ScrapeLogger.data.count }
      end
    end

    context 'when data was not scraped recently' do
      context 'when there are no tournaments with incomplete data' do
        let(:data_source_1) { create(:data_source, stat: 'putting from 3', stat_column_name: '% made') }
        let(:tournament_1) { create(:tournament, year: 1900, pga_id: 't000') }
        let(:tournament_2) { create(:tournament, year: 1900, pga_id: 't001') }

        before do
          create(:data_point, data_source: data_source_1, tournament: tournament_1)
          create(:data_point, data_source: data_source_1, tournament: tournament_2)
        end

        it 'does not make any requests' do
          service.scrape_data_from_all_tournaments

          expect(HTTParty).not_to have_received(:get)
        end

        it 'logs a scrape' do
          expect { service.scrape_data_from_all_tournaments }
            .to change { ScrapeLogger.data.count }
            .from(0).to(1)
        end
      end

      context 'when there are tournaments with incomplete data' do
        let(:tournament_1) { create(:tournament, year: 1900, pga_id: 't000') }
        let(:tournament_2) { create(:tournament, year: 1900, pga_id: 't001') }

        let(:data_source_1) { create(:data_source, stat: 'putting from 3', stat_column_name: '% made') }
        let!(:data_source_2) { create(:data_source, stat: 'stat 2', stat_column_name: '% made') }

        before do
          create(:data_point, data_source: data_source_1, tournament: tournament_1)
          create(:data_point, data_source: data_source_1, tournament: tournament_2)
        end

        it 'makes 1 request to the PGA site for each tournament, for the one unaccounted-for data source' do
          service.scrape_data_from_all_tournaments

          expect(HTTParty).to have_received(:get)
            .with("https://www.pgatour.com/stats/stat.#{data_source_2.pga_id}.y#{tournament_1.year}.eon.#{tournament_1.pga_id}.html")
          expect(HTTParty).to have_received(:get)
            .with("https://www.pgatour.com/stats/stat.#{data_source_2.pga_id}.y#{tournament_2.year}.eon.#{tournament_2.pga_id}.html")
          expect(HTTParty).to have_received(:get).exactly(2).times
        end

        it 'creates a new data point for each tournament/data-source/golfer combo' do
          expect(DataPoint.count).to eq(2)

          service.scrape_data_from_all_tournaments

          number_of_golfers_in_fixture = 5
          tournaments = Tournament.count
          initial_data_points = DataSource.count
          expected_count = initial_data_points + (number_of_golfers_in_fixture * tournaments)

          expect(DataPoint.count).to eq(expected_count)
          expect(DataPoint.last).to have_attributes({
            tournament: tournament_2,
            data_source: data_source_2,
            golfer: Golfer.find_by(name: "Bryson DeChambeau"),
            value: '100.00',
            rank: 1,
            })
        end

        it 'calculates the correlations within the tournament' do
          service.scrape_data_from_all_tournaments

          expect(CorrelationCalculator).to have_received(:calculate).with(tournament_1)
          expect(CorrelationCalculator).to have_received(:calculate).with(tournament_2)
        end

        it 'logs a scrape' do
          expect { service.scrape_data_from_all_tournaments }
            .to change { ScrapeLogger.data.count }
            .from(0).to(1)
        end
      end
    end
  end
end
