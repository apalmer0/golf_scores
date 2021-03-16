require 'rails_helper'

RSpec.describe Series, type: :model do
  describe 'associations' do
    it { should have_many(:tournaments) }
    it { should have_many(:correlations).through(:tournaments) }
    it { should have_many(:data_sources).through(:correlations) }
  end

  describe 'validations' do
    subject { create(:series) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:pga_id) }
    it { should validate_uniqueness_of(:pga_id) }
  end

  describe '.most_recent_tournament' do
    it 'returns the most recent tournament' do
      series = create(:series)
      t_2021 = create(:tournament, series: series, year: 2021)
      _t_2019 = create(:tournament, series: series, year: 2019)
      _t_2020 = create(:tournament, series: series, year: 2020)

      expect(series.most_recent_tournament).to eq(t_2021)
    end
  end

  describe '.outdated_name?' do
    let(:series) { create(:series, name: 'NAME') }

    context 'when there is no most_recent_tournament' do
      it 'returns false' do
        outdated = series.outdated_name?(2021, 'NAME')

        expect(outdated).to be(false)
      end
    end

    context 'when the given year is more recent than the tournament year' do
      context 'when the name is the same' do
        let!(:tournament) { create(:tournament, series: series, year: 2020, name: 'NAME') }

        it 'returns false' do
          outdated = series.outdated_name?(2021, 'NAME')

          expect(outdated).to be(false)
        end
      end

      context 'when the name is the different' do
        let!(:tournament) { create(:tournament, series: series, year: 2020, name: 'NAME') }

        it 'returns true' do
          outdated = series.outdated_name?(2021, 'NEW NAME')

          expect(outdated).to be(true)
        end
      end
    end

    context 'when the given year is the same or older than the tournament year' do
      let!(:tournament) { create(:tournament, series: series, year: 2020, name: 'NAME') }

      it 'returns false' do
        outdated = series.outdated_name?(2019, 'OLD_NAME')

        expect(outdated).to be(false)
      end
    end
  end

  describe '.sanitized_name' do
    it 'sanitizes names for use in URLs' do
      series_1 = build(:series, name: 'AT&T Pebble Beach Pro-Am')

      expect(series_1.sanitized_name).to eq('at-t-pebble-beach-pro-am')
    end
  end

  describe '.average_correlation_for' do
    it 'returns the average correlation for the given data source' do
      series = create(:series)
      tournament_1 = create(:tournament, series: series)
      tournament_2 = create(:tournament, series: series)
      tournament_3 = create(:tournament, series: series)
      data_source = create(:data_source)

      create(:correlation, tournament: tournament_1, data_source: data_source, coefficient: 0.25)
      create(:correlation, tournament: tournament_2, data_source: data_source, coefficient: 0.50)
      create(:correlation, tournament: tournament_3, data_source: data_source, coefficient: 0.75)

      expect(series.average_correlation_for(data_source)).to eq(0.5)
    end
  end
end
