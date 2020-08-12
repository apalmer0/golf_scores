FactoryBot.define do
  factory :scrape_logger do
    run_at { "2020-08-11 06:51:31" }
    role { :tournament }

    trait :tournament do
      role { :tournament }
    end

    trait :data do
      role { :data }
    end
  end
end
