require 'rails_helper'

RSpec.describe SeriesScraperWorker, type: :worker do
  describe '#perform' do

    subject(:worker) { SeriesScraperWorker.new }

    it 'calls #scrape_series_data on SeriesScraper' do
      service = instance_double(Scraper, scrape_series_data: true)
      allow(Scraper).to receive(:new).and_return(service)

      worker.perform('pga_id')

      expect(service).to have_received(:scrape_series_data).with('pga_id')
    end
  end
end
