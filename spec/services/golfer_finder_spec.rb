require 'rails_helper'

RSpec.describe GolferFinder, type: :service do
  describe '#find_or_initialize_by' do
    name = "Charles Howell III"

    context 'when there is a fuzzy match' do
      it 'returns the matched golfer' do
        golfer = create(:golfer, name: "Charles Howell")

        expect(GolferFinder.find_or_initialize_by(name)).to eq(golfer)
      end
    end

    context 'when there is no fuzzy match' do
      it 'returns a new golfer' do
        create(:golfer, name: "John Smith")

        allow(Golfer).to receive(:new)

        GolferFinder.find_or_initialize_by(name)

        expect(Golfer).to have_received(:new).with(name: name)
      end
    end
  end
end
