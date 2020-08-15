require 'rails_helper'

RSpec.describe Parser, type: :service do
  describe '#parse_table' do
    describe 'parsing data pages' do
      let(:unparsed_page) { File.read('spec/fixtures/limited_data/stats.html') }

      let(:service) { Parser.new(unparsed_page, data_source) }
      let(:data_source) do
        create(:data_source,
          stat: 'Putting from 3',
          stat_column_name: '% made'
        )
      end

      it 'returns an array of objects with the golfer name and the desired attribute' do
        data = service.parse_table

        expect(data.first).to eq({ name: "Phil Mickelson", stat: '100.00', rank: 1 })
      end
    end

    describe 'parsing results pages' do
      let(:unparsed_page) { File.read('spec/fixtures/limited_data/results.html') }

      let(:service) { Parser.new(unparsed_page, data_source) }
      let(:data_source) { create(:data_source, stat: 'results' ) }

      it 'returns an array of objects with the golfer name and the desired attribute' do
        data = service.parse_table

        expect(data.first).to eq({ name: "Bryson DeChambeau", stat: '266', rank: 1 })
        expect(data.last).to eq({ name: "Justin Thomas", stat: '273', rank: 8 })
      end
    end
  end
end
