class Scraper
  YEARS = [
    2015,
    2016,
    2017,
    2018,
    2019,
    2020,
  ]
  SECONDS_BETWEEN_REQUESTS = 5

  def self.scrape_new_tournaments
    new.scrape_new_tournaments
  end

  def self.scrape_data
    new.scrape_data
  end

  def scrape_all_tournaments
    return if tournament_scraped_recently?

    YEARS.each do |year|
      scrape_for_tournaments(year)

      sleep(SECONDS_BETWEEN_REQUESTS)
    end

    log_scrape(:tournament)
  end

  def scrape_new_tournaments
    return if tournament_scraped_recently?

    scrape_for_tournaments(2020)

    log_scrape(:tournament)
  end

  def scrape_data
    return if data_scraped_recently?

    Tournament.with_incomplete_data.each do |tournament|
      DataSource.not_yet_pulled_for(tournament).each do |source|
        url = url_builder(source, tournament)

        unparsed_page = HTTParty.get(url)
        results = Parser.parse_table(unparsed_page, source)

        results.each do |data|
          golfer = GolferFinder.find_or_create_by(data[:name])

          DataPoint.create(
            tournament: tournament,
            golfer: golfer,
            data_source: source,
            value: data[:stat],
            rank: data[:rank],
          )
        end

        sleep(SECONDS_BETWEEN_REQUESTS)
      end
    end

    log_scrape(:data)
  end

  private

  def data_scraped_recently?
    return false if !ScrapeLogger.data.last

    ScrapeLogger.data.last.run_at > 1.hour.ago
  end

  def tournament_scraped_recently?
    return false if !ScrapeLogger.tournament.last

    ScrapeLogger.tournament.last.run_at > 1.hour.ago
  end

  def log_scrape(role)
    ScrapeLogger.create(
      run_at: DateTime.current,
      role: role,
    )
  end

  def scrape_for_tournaments(year)
    url = "https://www.pgatour.com/stats/stat.02674.y#{year}.eon.t033.html"
    unparsed_page = HTTParty.get(url)
    parsed_tournaments = Parser.parse_tournaments(unparsed_page)

    parsed_tournaments.each do |tournament_data|
      data = {
        **tournament_data,
        year: year,
      }

      Tournament.find_or_create_by(data)
    end
  end

  def url_builder(source, tournament)
    if source.stat == 'results'
      name = tournament.name.gsub(" ", "-").downcase

      "https://www.pgatour.com/tournaments/#{name}/past-results/jcr:content/mainParsys/pastresults.selectedYear.#{tournament.year}.html"
    else
      "https://www.pgatour.com/content/pgatour/stats/stat.#{source.pga_id}.y#{tournament.year}.eon.#{tournament.pga_id}.html"
    end
  end
end
