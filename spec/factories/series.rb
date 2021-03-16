FactoryBot.define do
  factory :series do
    sequence(:name) { |n| "tournament-#{n}" }
    sequence(:pga_id) { |n| "t#{"%03d" % n}" }
  end
end
