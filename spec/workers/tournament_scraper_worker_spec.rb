require 'rails_helper'

RSpec.describe TournamentScraperWorker, type: :worker do
  describe '#perform' do
    let(:scraper) { instance_double(Scraper) }

    before do
      allow(scraper).to receive(:scrape_tournament_series)
      allow(Scraper).to receive(:new).and_return(scraper)
    end

    subject(:worker) { TournamentScraperWorker.new }

    it 'calls #scrape_tournament_series on TournamentScraper with the correct args' do
      worker.perform('t000')

      expect(scraper).to have_received(:scrape_tournament_series).with('t000')
    end
  end
end
