class Tournament < ApplicationRecord
  include PgSearch

  belongs_to :series

  has_many :correlations
  has_many :data_sources, through: :correlations

  validates :name, presence: true
  validates :year, presence: true
  validates :year, uniqueness: { scope: :series_id }

  pg_search_scope :search_by_name, against: [:name]

  def self.with_incomplete_data
    # wildly inefficient. figure out how to improve this query.
    tournaments = Tournament.includes(:data_sources).select { |t| t.data_sources.uniq.count < DataSource.count }

    Tournament.where(id: tournaments.pluck(:id))
  end

  def sources_scraped
    data_sources.uniq
  end
end
