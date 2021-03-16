class Series < ApplicationRecord
  include PgSearch

  has_many :tournaments
  has_many :correlations, through: :tournaments
  has_many :data_sources, through: :correlations

  validates :name, presence: true
  validates :pga_id, presence: true
  validates :pga_id, uniqueness: true

  pg_search_scope :search_by_name, against: [:name]

  def most_recent_tournament
    tournaments.order(year: :desc).first
  end

  def outdated_name?(year, name)
    return false if !most_recent_tournament

    most_recent_tournament.year < year && most_recent_tournament.name != name
  end

  def sanitized_name
    name.gsub('& ', '').gsub('&', '-').gsub(" ", "-").downcase
  end

  def average_correlation_for(data_source)
    # TODO: improve this.
    sum = correlations.where(data_source: data_source).reduce(0) do |accumulator, memo|
      accumulator + memo.coefficient
    end
    count = correlations.where(data_source: data_source).count

    sum / count
  end
end
