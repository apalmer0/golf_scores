FactoryBot.define do
  factory :tournament do
    series
    sequence(:name) { |n| "tournament-#{n}" }
    sequence(:year) { |n| n + 1000 }
  end
end
