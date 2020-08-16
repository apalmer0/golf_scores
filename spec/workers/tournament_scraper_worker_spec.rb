require 'rails_helper'

RSpec.describe TournamentScraperWorker, type: :worker do
  describe '#perform' do

    subject(:worker) { TournamentScraperWorker.new }

    it 'calls #scrape_for_new_tournaments on TournamentScraper' do
      allow(Scraper).to receive(:scrape_for_new_tournaments)

      worker.perform

      expect(Scraper).to have_received(:scrape_for_new_tournaments)
    end
  end
end
