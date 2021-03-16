class Parser
  STATS_TABLE_LOCATION = 'table#statsTable'.freeze
  RESULTS_TABLE_LOCATION = 'table.table-styled'.freeze
  TOURNAMENT_DROPDOWN = '.statistics-details-select--tournament'.freeze
  STATS_PLAYER_NAME = 'player name'.freeze
  RESULTS_PLAYER_NAME = 'player'.freeze
  RESULTS_COLUMN = 'span.position.round-4'.freeze
  RANK_COLUMN = 'rank this week'.freeze

  def self.create_stats_object(unparsed_page, data_source, names = [])
    new(unparsed_page, data_source, names).create_stats_object
  end

  def self.parse_tournaments(unparsed_page)
    new(unparsed_page, nil, nil).parse_tournaments
  end

  def initialize(unparsed_page, data_source, names)
    @unparsed_page = unparsed_page
    @data_source = data_source
    @names = names
  end

  def create_stats_object
    table_rows.each_with_object({}).with_index do |(row, hash), index|
      row_data = row.css('td').map { |td| td.text.gsub("\t", "").strip }

      value = data_source.results_stat? ? finish[index] : row_data[rank_index].delete('^0-9').to_i

      golfer_name = GolferFinder.find_or_create_by(row_data[name_index], names)

      hash[golfer_name] = value
    end
  end

  def parse_tournaments
    tournament_options.map do |option|
      {
        pga_id: option.values[0],
        name: option.text,
      }
    end
  end

  private

  attr_reader :data_source, :unparsed_page, :names

  def parsed_page
    @parsed_page ||= Nokogiri::HTML(unparsed_page)
  end

  def tournament_options
    @tournament_options ||= parsed_page.css(TOURNAMENT_DROPDOWN).css('option')
  end

  def table
    table_location = data_source.results_stat? ? RESULTS_TABLE_LOCATION : STATS_TABLE_LOCATION

    @table ||= parsed_page.css(table_location)
  end

  def headers
    @headers ||= table.css('th').map do |th|
      th.text
        .gsub("\u00A0", " ")
        .split("\n")
        .map(&:strip)
        .join(" ")
        .strip
        .downcase
    end
  end

  def table_rows
    @table_rows ||= table.css('tbody').css('tr')
  end

  def scores
    @scores ||= table_rows.map { |row| row.css(RESULTS_COLUMN).text }
  end

  def finish
    @finish ||= scores.map { |score| scores.index(score) + 1 }
  end

  def name_index
    @name_index ||= data_source.results_stat? ? headers.index(RESULTS_PLAYER_NAME) : headers.index(STATS_PLAYER_NAME)
  end

  def rank_index
    @rank_index ||= headers.index(RANK_COLUMN)
  end
end
