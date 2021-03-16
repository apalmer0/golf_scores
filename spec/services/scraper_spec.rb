require 'rails_helper'

RSpec.describe Scraper, type: :service do
  let(:stats_data) { File.read('spec/fixtures/limited_data/stats.html') }
  let(:service) { Scraper.new }

  describe '#scrape_for_all_tournaments' do
    before(:each) do
      allow(HTTParty).to receive(:get).and_return(stats_data)
      allow_any_instance_of(Scraper).to receive(:sleep)
      allow(Pearson).to receive(:coefficient).and_return(0.9876)
    end

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
    before(:each) do
      allow(HTTParty).to receive(:get).and_return(stats_data)
      allow_any_instance_of(Scraper).to receive(:sleep)
      allow(Pearson).to receive(:coefficient).and_return(0.9876)
    end

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

  describe '.calculate_correlations_for' do
    let(:results_data) { File.read('spec/fixtures/limited_data/results.html') }
    let(:service) { Scraper.new }
    let(:tournament) { create(:tournament) }
    let!(:results_stat) { create(:data_source, stat: DataSource::RESULTS) }
    let!(:other_stat_1) { create(:data_source, stat: 'stat_1') }

    before(:each) do
      allow(HTTParty).to receive(:get).and_return(results_data, stats_data)
      allow_any_instance_of(Scraper).to receive(:sleep)
      allow(Pearson).to receive(:coefficient).and_return(0.9876)
    end

    it 'fetches results for the tournament' do
      results_url = 'www.example.com/results'
      allow(UrlBuilder).to receive(:build).and_return(results_url, stats_data)

      service.calculate_correlations_for(tournament)

      expect(HTTParty).to have_received(:get).with(results_url)
    end

    context 'when tournament results arent present' do
      before do
        allow(HTTParty).to receive(:get).and_return(nil)
      end

      it 'does not fetch stats for each stat' do
        results_url = 'www.example.com/results'
        allow(UrlBuilder).to receive(:build).with(results_stat, tournament).and_return(results_url)

        service.calculate_correlations_for(tournament)

        expect(HTTParty).to have_received(:get).once.with(results_url)
      end

      it 'does not calculate the correlation between the stat and the results' do
        service.calculate_correlations_for(tournament)

        expect(Pearson).not_to have_received(:coefficient)
      end

      it 'does not create a Correlation record for the tournament and data source' do
        expect { service.calculate_correlations_for(tournament) }
          .not_to change { Correlation.count }
      end
    end

    context 'when tournament results are present' do
      it 'fetches stats for each stat' do
        service.calculate_correlations_for(tournament)

        expect(HTTParty).to have_received(:get).exactly(2).times
      end

      it 'calculates the correlation between the stat and the results' do
        data = {
          finishes: {
            "Bryson DeChambeau" => 1,
            "Tony Finau" => 2,
            "Billy Horschel" => 3,
            "Cameron Smith" => 3,
            "Ryan Palmer" => 5,
            "Adam Scott" => 5,
            "Aaron Wise" => 5,
            "Patrick Cantlay" => 8,
            "Brooks Koepka" => 8,
            "Justin Thomas" => 8,
          },
          stats: {
            "Phil Mickelson" => 1,
            "Jim Furyk" => 2,
            "Justin Thomas" => 3,
            "Rory McIlroy" => 4,
            "Bryson DeChambeau" => 4,
          }
        }
        service.calculate_correlations_for(tournament)

        expect(Pearson).to have_received(:coefficient).with(data, :finishes, :stats)
      end

      it 'creates a Correlation record for the tournament and data source' do
        expect { service.calculate_correlations_for(tournament) }
          .to change { Correlation.count }.from(0).to(1)

        expect(Correlation.last).to have_attributes({
          tournament_id: tournament.id,
          data_source: other_stat_1,
          coefficient: 0.9876,
        })
      end
    end
  end
end
