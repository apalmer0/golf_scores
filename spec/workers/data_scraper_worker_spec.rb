require 'rails_helper'

RSpec.describe DataScraperWorker, type: :worker do
  describe '#perform' do

    subject(:worker) { DataScraperWorker.new }

    it 'calls #scrape_tournament_data on DataScraper' do
      allow(Scraper).to receive(:scrape_tournament_data)

      worker.perform

      expect(Scraper).to have_received(:scrape_tournament_data)
    end
  end
end
