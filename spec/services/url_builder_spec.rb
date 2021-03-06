require 'rails_helper'

RSpec.describe UrlBuilder, type: :service do
  describe 'when the data source is for results' do
    it 'returns a url for the results page using the name of the most-recent tournament with the same pga_id' do
      source = create(:data_source, stat: DataSource::RESULTS, pga_id: 'sourceId')
      series_1 = create(:series, pga_id: 'tourneyId', name: 'Correct & Name')
      series_2 = create(:series, pga_id: 'differentTourneyId', name: 'AT&T Pebble Beach Pro-Am')
      tournament1c = create(:tournament, year: 2015, series: series_1, name: 'Wrong Name')
      tournament1b = create(:tournament, year: 2016, series: series_1, name: 'Also Wrong')
      tournament1a = create(:tournament, year: 2017, series: series_1, name: 'Correct & Name')
      tournament2 = create(:tournament, year: 2018, series: series_2, name: 'AT&T Pebble Beach Pro-Am')

      expect(UrlBuilder.build(source, tournament1c)).to eql("https://www.pgatour.com/tournaments/correct-name/past-results/jcr:content/mainParsys/pastresults.selectedYear.2015.html")
      expect(UrlBuilder.build(source, tournament1b)).to eql("https://www.pgatour.com/tournaments/correct-name/past-results/jcr:content/mainParsys/pastresults.selectedYear.2016.html")
      expect(UrlBuilder.build(source, tournament1a)).to eql("https://www.pgatour.com/tournaments/correct-name/past-results/jcr:content/mainParsys/pastresults.selectedYear.2017.html")
      expect(UrlBuilder.build(source, tournament2)).to eql("https://www.pgatour.com/tournaments/at-t-pebble-beach-pro-am/past-results/jcr:content/mainParsys/pastresults.selectedYear.2018.html")
    end
  end

  describe 'when the data source is for stats' do
    it 'returns a url for the stats page' do
      source = create(:data_source, stat: 'birdies', pga_id: 'sourceId')
      series = create(:series, pga_id: 'tourneyId')
      tournament = create(:tournament, year: 2019, series: series)

      expect(UrlBuilder.build(source, tournament)).to eql("https://www.pgatour.com/stats/stat.sourceId.y2019.eon.tourneyId.html")
    end
  end
end
