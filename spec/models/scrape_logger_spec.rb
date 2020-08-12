require 'rails_helper'

RSpec.describe ScrapeLogger, type: :model do
  describe "validations" do
    it { should validate_presence_of(:run_at) }
  end
end
