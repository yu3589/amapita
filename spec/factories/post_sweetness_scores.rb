FactoryBot.define do
  factory :post_sweetness_score do
    association :post
    sweetness_strength { rand(0..4) }
    aftertaste_clarity { rand(0..4) }
    natural_sweetness { rand(0..4) }
    sweetness_strength { rand(0..4) }
    coolness { rand(0..4) }
    richness { rand(0..4) }
  end
end
