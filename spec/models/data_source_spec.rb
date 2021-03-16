require 'rails_helper'

RSpec.describe DataSource, type: :model do
  describe 'associations' do
    it { should have_many(:correlations) }
    it { should have_many(:tournaments).through(:correlations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:pga_id) }
    it { should validate_uniqueness_of(:pga_id) }
    it { should validate_presence_of(:stat) }
    it { should validate_uniqueness_of(:stat) }
  end

  describe '.not_yet_pulled_for' do
    it "returns data sources that aren't associated with a tournament" do
      data_source_1 = create(:data_source)
      data_source_2 = create(:data_source)

      tournament = create(:tournament)

      create(:correlation, tournament: tournament, data_source: data_source_1)

      expect(DataSource.not_yet_pulled_for(tournament)).to match_array([data_source_2])
    end
  end
end
