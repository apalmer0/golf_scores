require 'rails_helper'

RSpec.describe DataPoint, type: :model do
  describe 'associations' do
    it { should belong_to(:data_source) }
    it { should belong_to(:golfer) }
    it { should belong_to(:tournament) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:rank) }
  end
end
