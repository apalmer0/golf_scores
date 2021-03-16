require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe 'associations' do
    it { should belong_to(:series) }
    it { should have_many(:correlations) }
    it { should have_many(:data_sources).through(:correlations) }
  end

  describe 'validations' do
    subject { create(:tournament) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:year) }
    it { should validate_uniqueness_of(:year).scoped_to(:series_id) }
  end

  describe '.with_incomplete_data' do
    context 'when there are no Tournaments with incomplete data' do
      let(:data_source_1) { create(:data_source, stat: 'putting from 3') }
      let(:tournament_1) { create(:tournament, year: 1900) }
      let(:tournament_2) { create(:tournament, year: 1900) }

      before do
        create(:correlation, data_source: data_source_1, tournament: tournament_1)
        create(:correlation, data_source: data_source_1, tournament: tournament_2)
      end

      it 'returns an empty association' do
        expect(Tournament.with_incomplete_data).to match_array([])
      end
    end

    context 'when there are Tournaments with incomplete data' do
      let(:data_source_1) { create(:data_source, stat: 'putting from 3') }
      let(:tournament_1) { create(:tournament, year: 1900) }
      let(:tournament_2) { create(:tournament, year: 1900) }

      before do
        create(:correlation, data_source: data_source_1, tournament: tournament_1)
        create(:correlation, data_source: data_source_1, tournament: tournament_2)
      end

      context 'when a new data source is added' do
        before do
          create(:data_source, stat: 'putting from 4')
        end

        it 'returns all tournaments whose associated data sources dont include all data sources' do
          expect(Tournament.with_incomplete_data).to match_array([
            tournament_1,
            tournament_2,
          ])
        end
      end

      context 'when a new tournament is added' do
        let!(:tournament_3) { create(:tournament) }

        it 'returns all tournaments whose associated data sources dont include all data sources' do
          expect(Tournament.with_incomplete_data).to match_array([tournament_3])
        end
      end
    end
  end
end
