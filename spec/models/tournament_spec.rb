require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe 'associations' do
    it { should have_many(:data_points) }
    it { should have_many(:golfers).through(:data_points) }
    it { should have_many(:data_sources).through(:data_points) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:year) }
    it { should validate_uniqueness_of(:pga_id).scoped_to(:year) }
  end

  describe '.with_incomplete_data' do
    context 'when there are no Tournaments with incomplete data' do
      let(:data_source_1) { create(:data_source, stat: 'putting from 3', stat_column_name: '% made') }
      let(:tournament_1) { create(:tournament, year: 1900, pga_id: 't000') }
      let(:tournament_2) { create(:tournament, year: 1900, pga_id: 't001') }

      before do
        create(:data_point, data_source: data_source_1, tournament: tournament_1)
        create(:data_point, data_source: data_source_1, tournament: tournament_2)
      end

      it 'returns an empty association' do
        expect(Tournament.with_incomplete_data).to match_array([])
      end
    end

    context 'when there are Tournaments with incomplete data' do
      let(:data_source_1) { create(:data_source, stat: 'putting from 3', stat_column_name: '% made') }
      let(:tournament_1) { create(:tournament, year: 1900, pga_id: 't000') }
      let(:tournament_2) { create(:tournament, year: 1900, pga_id: 't001') }

      before do
        create(:data_point, data_source: data_source_1, tournament: tournament_1)
        create(:data_point, data_source: data_source_1, tournament: tournament_2)
      end

      context 'when a new data source is added' do
        before do
          create(:data_source, stat: 'putting from 4', stat_column_name: '% made')
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
