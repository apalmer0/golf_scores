class Scraper
  def self.scrape_data(years)
    new(years).scrape_data
  end

  def self.scrape_all
    new([2019, 2020]).scrape_data
  end

  def self.scrape_2019
    new([2019]).scrape_data
  end

  def self.scrape_2020
    new([2020]).scrape_data
  end

  def initialize(years)
    @years = years
  end

  def scrape_data
    scrape_sources(data_sources)
  end

  def scrape_sources(sources)
    sources.each do |source|
      scrape_source(source)

      sleep(5)
    end
  end

  def scrape_source(source)
    unparsed_page = HTTParty.get(source.url)
    parsed_data = Parser.parse_table(source, unparsed_page)
    parsed_data.each do |golfer_data|
      golfer = golfers.find(golfer_data[:name], threshold: 0.5)

      if golfer
        golfer.update(golfer_data)
      else
        Golfer.create(golfer_data)
      end
    end

    source.update(last_fetched: DateTime.current)
  end

  private

  attr_reader :years

  def data_sources
    @data_sources ||= DataSource.where(year: years)
  end

  def golfers
    FuzzyMatch.new(Golfer.all, read: :name)
  end
end
