# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Category.find_by(name: "パン・ドーナツ")&.update!(name: "ドーナツ")
Category.find_by(name: "クッキー・ビスケット")&.update!(name: "クッキー")

categories = [
  { name: "チョコレート", slug: "chocolate" },
  { name: "グミ・ゼリー", slug: "gummy-jelly" },
  { name: "クッキー", slug: "cookie" },
  { name: "ケーキ", slug: "cake" },
  { name: "アイス", slug: "ice-cream" },
  { name: "飲み物", slug: "drink" },
  { name: "ドーナツ", slug: "doughnut" },
  { name: "スナック菓子", slug: "snack" },
  { name: "その他", slug: "other" }
]

categories.each do |cat|
  category = Category.find_or_initialize_by(name: cat[:name])
  category.slug = cat[:slug]
  category.save!
end

badges = [
  { name: "甘さツイン", badge_kind: 1, threshold: nil },
  { name: "スイーツマスターLv.1", badge_kind: 0, threshold: 1 },
  { name: "甘の冒険者", badge_kind: 0, threshold: 5 },
  { name: "甘界の番長", badge_kind: 0, threshold: 10 },
  { name: "甘の大天使", badge_kind: 0, threshold: 15 },
  { name: "甘界の覇者", badge_kind: 0, threshold: 30 },
  { name: "伝説のあまピタ民", badge_kind: 0, threshold: 50 }
]

badges.each do |b|
  badge = Badge.find_or_initialize_by(name: b[:name])
  badge.update!(
    badge_kind: b[:badge_kind],
    threshold: b[:threshold]
  )
end
