require 'rails_helper'

RSpec.describe Parser, type: :service do
  describe '#create_stats_object' do
    describe 'parsing data pages' do
      let(:unparsed_page) { File.read('spec/fixtures/limited_data/stats.html') }
      let(:names) do
        [
          "Phil Mickelson",
          "Jim Furyk",
          "Justin Thomas",
          "Rory McIlroy",
          "Bryson DeChambeau",
        ]
      end

      let(:service) { Parser.new(unparsed_page, data_source, names) }
      let(:data_source) { create(:data_source, stat: 'Putting from 3') }

      it 'returns an object with the golfer name as the key and the rank as the value' do
        data = service.create_stats_object

        expect(data).to eq({
          "Phil Mickelson" => 1,
          "Jim Furyk" => 2,
          "Justin Thomas" => 3,
          "Rory McIlroy" => 4,
          "Bryson DeChambeau" => 4,
        })
      end
    end

    describe 'parsing results pages' do
      let(:unparsed_page) { File.read('spec/fixtures/limited_data/results.html') }
      let(:names) do
        [
          "Bryson DeChambeau",
          "Tony Finau",
          "Billy Horschel",
          "Cameron Smith",
          "Ryan Palmer",
          "Adam Scott",
          "Aaron Wise",
          "Patrick Cantlay",
          "Brooks Koepka",
          "Justin Thomas",
        ]
      end

      let(:service) { Parser.new(unparsed_page, data_source, names) }
      let(:data_source) { create(:data_source, stat: 'results' ) }

      it 'returns an object with the golfer name as the key and the rank as the value' do
        data = service.create_stats_object

        expect(data).to eq({
          "Bryson DeChambeau" => 1,
          "Tony Finau" => 2,
          "Billy Horschel" => 3,
          "Cameron Smith" => 3,
          "Ryan Palmer" => 5,
          "Adam Scott" => 5,
          "Aaron Wise" => 5,
          "Patrick Cantlay" => 8,
          "Brooks Koepka" => 8,
          "Justin Thomas" => 8,
        })
      end
    end
  end
end
