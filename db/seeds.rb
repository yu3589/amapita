# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Category.find_by(name: "ケーキ・洋菓子")&.update!(name: "ケーキ")
Category.find_by(name: "アイス・冷菓")&.update!(name: "アイス")
Category.find_by(name: "ドーナツ")&.update!(name: "パン・ドーナツ")

Category.find_by(name: "和菓子")&.destroy!
Category.find_by(name: "パン")&.destroy!
Category.find_by(name: "キャンディ・あめ")&.destroy!

categories = [
  { name: "チョコレート", slug: "chocolate" },
  { name: "グミ・ゼリー", slug: "gummy-jelly" },
  { name: "クッキー・ビスケット", slug: "cookie-biscuit" },
  { name: "ケーキ", slug: "cake" },
  { name: "アイス", slug: "ice-cream" },
  { name: "飲み物", slug: "drink" },
  { name: "パン・ドーナツ", slug: "bread-doughnut" },
  { name: "スナック菓子", slug: "snack" },
  { name: "その他", slug: "other" }
]

categories.each do |cat|
  category = Category.find_or_initialize_by(name: cat[:name])
  category.slug = cat[:slug]
  category.save!
end

products = [
  {
    category_name: "チョコレート",
    name: "ポッキー",
    manufacturer: "グリコ"
  },
    {
    category_name: "グミ・ゼリー",
    name: "果汁グミ ぶどう",
    manufacturer: "明治"
  },
    {
    category_name: "クッキー・ビスケット",
    name: "オレオ",
    manufacturer: "ナビスコ"
  },
  {
    category_name: "ケーキ",
    name: "プレミアムロールケーキ",
    manufacturer: "ローソン"
  },
  {
    category_name: "アイス",
    name: "雪見だいふく",
    manufacturer: "ロッテ"
  },
  {
    category_name: "飲み物",
    name: "午後の紅茶 ミルクティー",
    manufacturer: "キリン"
  },
  {
    category_name: "パン・ドーナツ",
    name: "ポン・デ・リング",
    manufacturer: "ミスタードーナツ"
  },
  {
    category_name: "スナック菓子",
    name: "キャラメルコーン",
    manufacturer: "東ハト"
  },
  {
    category_name: "その他",
    name: "なめらかプリン",
    manufacturer: "パステル"
  }
]

products.each do |p|
  category = Category.find_by!(name: p[:category_name])
  Product.find_or_create_by!(
    name: p[:name],
    manufacturer: p[:manufacturer],
    category_id: category.id
  )
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
