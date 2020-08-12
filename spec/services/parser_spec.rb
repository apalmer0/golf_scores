require 'rails_helper'

RSpec.describe Parser, type: :service do
  describe '#parse_table' do
    unparsed_page = File.read('spec/fixtures/limited_data/pga.html')

    let(:service) { Parser.new(unparsed_page, data_source) }

    describe 'when the column_name attributes are correct' do
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
  end
end
