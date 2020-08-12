FactoryBot.define do
  factory :tournament do
    sequence(:name) { |n| "tournament-#{n}" }
    sequence(:pga_id) { |n| "t#{"%03d" % n}" }
    year 2020
  end
end
