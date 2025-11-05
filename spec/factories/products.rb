FactoryBot.define do
  factory :product do
    association :user
    association :category
    name { "トッポ" }
    manufacturer { Faker::Company.name }
  end
end
