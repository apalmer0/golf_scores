require 'rails_helper'

RSpec.describe Correlation, type: :model do
  describe 'associations' do
    it { should belong_to(:tournament) }
    it { should belong_to(:data_source) }
  end

  describe 'validations' do
    subject { create(:correlation) }

    it { should validate_presence_of(:coefficient) }
    it { should validate_uniqueness_of(:data_source_id).scoped_to(:tournament_id) }
  end
end
