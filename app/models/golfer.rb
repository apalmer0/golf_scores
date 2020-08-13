class Golfer < ApplicationRecord
  include PgSearch

  has_many :data_points
  has_many :tournaments, through: :data_points

  validates :name, presence: true, uniqueness: true

  pg_search_scope :search_by_name, against: [:name]
end
