require 'rails_helper'

RSpec.describe Golfer, type: :model do
  describe "associations" do
    it { should have_many(:data_points) }
    it { should have_many(:tournaments).through(:data_points) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
