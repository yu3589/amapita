FactoryBot.define do
  factory :post do
    association :user
    association :product
    sweetness_rating { :perfect_sweetness }
    review { Faker::Lorem.paragraph }
    status { :publish }

    after(:build) do |post|
      unless post.post_sweetness_score
        post.build_post_sweetness_score(
          sweetness_strength: rand(0..4),
          aftertaste_clarity: rand(0..4),
          natural_sweetness: rand(0..4),
          coolness: rand(0..4),
          richness: rand(0..4)
        )
      end
    end
  end
end
