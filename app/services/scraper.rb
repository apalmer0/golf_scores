class Scraper
  YEARS = [2016,2017,2018,2019,2020,2021]
  SECONDS_BETWEEN_REQUESTS = 5
  ARBITRARY_STAT = "02674".freeze
  ARBITRARY_TOURNAMENT = "t033".freeze

  def self.scrape_for_new_tournaments
    new.scrape_for_new_tournaments
  end

  def self.scrape_tournament_data
    new.scrape_tournament_data
  end

  def scrape_for_all_tournaments
    return if tournament_scraped_recently?

    YEARS.each do |year|
      scrape_for_tournaments(year)

      sleep(SECONDS_BETWEEN_REQUESTS)
    end

    log_scrape(:tournament)
  end

  def scrape_for_new_tournaments
    return if tournament_scraped_recently?

    scrape_for_tournaments(2020)

    log_scrape(:tournament)
  end

  def scrape_series_data(pga_id)
    return if data_scraped_recently?

    Series.find_by(pga_id: pga_id).tournaments.with_incomplete_data.each do |tournament|
      calculate_correlations_for(tournament)
    end

    log_scrape(:data)
  end

  def scrape_tournament_data
    return if data_scraped_recently?

    Tournament.with_incomplete_data.each do |tournament|
      calculate_correlations_for(tournament)
    end

    log_scrape(:data)
  end

  def calculate_correlations_for(tournament)
    tournament_results = get_results_for(tournament)

    return if tournament_results.empty?

    golfer_names = tournament_results.keys

    DataSource.stats.not_yet_pulled_for(tournament).each do |source|
      source_stats = scrape_data_source(source, tournament, golfer_names)

      data = {
        finishes: tournament_results,
        stats: source_stats,
      }

      coefficient = Pearson.coefficient(data, :finishes, :stats).truncate(4)

      Correlation.create(tournament_id: tournament.id, data_source: source, coefficient: coefficient)
    end
  end

  def get_results_for(tournament)
    source = DataSource.results
    url = UrlBuilder.build(source, tournament)
    unparsed_page = HTTParty.get(url)

    Parser.create_stats_object(unparsed_page, source)
  end

  def scrape_data_source(source, tournament, names)
    url = UrlBuilder.build(source, tournament)
    unparsed_page = HTTParty.get(url)
    results = Parser.create_stats_object(unparsed_page, source, names)

    puts "\n\nPausing between requests...\n\n"
    sleep(SECONDS_BETWEEN_REQUESTS)

    return results
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
    url = "https://www.pgatour.com/stats/stat.#{ARBITRARY_STAT}.y#{year}.eon.#{ARBITRARY_TOURNAMENT}.html"
    unparsed_page = HTTParty.get(url)
    parsed_tournaments = Parser.parse_tournaments(unparsed_page)

    parsed_tournaments.each do |tournament_data|
      data = {
        name: tournament_data[:name],
        series: tournament_series(tournament_data, year),
        year: year,
      }

      Tournament.find_or_create_by(data)
    end
  end

  def tournament_series(data, year)
    series = Series.find_by(pga_id: data[:pga_id])

    if series
      if series.outdated_name?(year, data[:name])
        series.update(name: data[:name])
      end
    else
      series = Series.create(data)
    end

    series
  end
end
