class Golfer < ApplicationRecord
  has_many :data_points
  has_many :tournaments, through: :data_points

  validates :name, presence: true, uniqueness: true
end
