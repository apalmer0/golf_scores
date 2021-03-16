require 'rails_helper'

RSpec.describe GolferFinder, type: :service do
  describe '#find_or_create_by' do
    context 'when there are no names to match' do
      it 'returns the given name' do
        name = "Bryson DeChambeau"
        all_names = []

        expect(GolferFinder.find_or_create_by(name, all_names)).to eq("Bryson DeChambeau")
      end
    end

    context 'when there is a fuzzy match' do
      it 'returns the matched golfer name' do
        name = "Charley Howell"
        all_names = ["Charles Howell III", "John Smith"]

        expect(GolferFinder.find_or_create_by(name, all_names)).to eq("Charles Howell III")
      end
    end

    context 'when there is no fuzzy match' do
      it 'returns the given name' do
        name = "Bryson DeChambeau"
        all_names = ["Charles Howell III", "John Smith"]

        expect(GolferFinder.find_or_create_by(name, all_names)).to eq("Bryson DeChambeau")
      end
    end
  end
end
