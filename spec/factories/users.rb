FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    uid { SecureRandom.urlsafe_base64 }
  end

  factory :google_user, class: User do
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { "googleuser123" }
  end
end
