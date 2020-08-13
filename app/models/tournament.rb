class Tournament < ApplicationRecord
  include PgSearch

  has_many :data_points
  has_many :golfers, through: :data_points
  has_many :data_sources, through: :data_points

  validates :name, presence: true
  validates :pga_id, uniqueness: { scope: [:year] }
  validates :year, presence: true

  pg_search_scope :search_by_name, against: [:name]

  def self.with_incomplete_data
    tournaments = Tournament.includes(:data_sources).select { |t| t.data_sources.uniq.count < DataSource.count }

    Tournament.where(id: tournaments.pluck(:id))
  end

  def sources_scraped
    data_sources.uniq
  end
end
