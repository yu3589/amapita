FactoryBot.define do
  factory :product do
    association :user
    association :category
    name { Faker::Food.dish }
    manufacturer { Faker::Company.name }
  end
end
