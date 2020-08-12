class Parser
  TABLE_LOCATION = 'table#statsTable'.freeze
  TOURNAMENT_DROPDOWN = '.statistics-details-select--tournament'.freeze
  PLAYER_NAME = 'player name'.freeze
  RANK_COLUMN = 'rank this week'.freeze

  def self.parse_table(unparsed_page, data_source)
    new(unparsed_page, data_source).parse_table
  end

  def self.parse_tournaments(unparsed_page)
    new(unparsed_page, nil).parse_tournaments
  end

  def initialize(unparsed_page, data_source)
    @unparsed_page = unparsed_page
    @data_source = data_source
  end

  def parse_table
    data
  end

  def parse_tournaments
    tournaments
  end

  private

  attr_reader :data_source, :unparsed_page

  def parsed_page
    @parsed_page ||= Nokogiri::HTML(unparsed_page)
  end

  def tournament_options
    @tournament_options ||= parsed_page.css(TOURNAMENT_DROPDOWN).css('option')
  end

  def tournaments
    @tournaments ||= tournament_options.map do |option|
      {
        pga_id: option.values[0],
        name: option.text,
      }
    end
  end

  def table
    @table ||= parsed_page.css(TABLE_LOCATION)
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

  def data
    @data ||= table_rows.map do |tr|
      row_data = tr.css('td').map { |td| td.text.gsub("\t", "").strip }

      {
        name: row_data[name_index],
        rank: row_data[rank_index].delete('^0-9').to_i,
        stat: row_data[stat_index],
      }

    end.compact
  end

  def name_index
    @name_index ||= headers.index(PLAYER_NAME)
  end

  def rank_index
    @rank_index ||= headers.index(RANK_COLUMN)
  end

  def stat_index
    @stat_index ||= headers.index(data_source.stat_column_name)
  end
end
