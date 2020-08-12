require 'rails_helper'

RSpec.describe DataSource, type: :model do
  describe 'associations' do
    it { should have_many(:data_points) }
  end

  describe 'validations' do
    it { should validate_presence_of(:pga_id) }
    it { should validate_uniqueness_of(:pga_id) }
    it { should validate_presence_of(:stat_column_name) }
    it { should validate_presence_of(:stat) }
    it { should validate_uniqueness_of(:stat) }
  end

  describe '.not_yet_pulled_for' do
    it 'returns data sources that arent associated with a tournament' do
      data_source_1 = create(:data_source)
      data_source_2 = create(:data_source)
      golfer_1 = create(:golfer)
      golfer_2 = create(:golfer)

      tournament = create(:tournament)

      create(:data_point, golfer: golfer_1, data_source: data_source_1, tournament: tournament)
      create(:data_point, golfer: golfer_2, data_source: data_source_1, tournament: tournament)

      expect(DataSource.not_yet_pulled_for(tournament)).to match_array([data_source_2])
    end
  end
end
