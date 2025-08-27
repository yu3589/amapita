# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

categories = [
  { name: "チョコレート" },
  { name: "グミ・ゼリー" },
  { name: "クッキー・ビスケット" },
  { name: "ケーキ・洋菓子" },
  { name: "和菓子" },
  { name: "アイス・冷菓" },
  { name: "飲み物" },
  { name: "キャンディ・あめ" },
  { name: "ドーナツ" },
  { name: "パン" },
  { name: "スナック菓子" },
  { name: "その他" }
]

categories.each do |cat|
  Category.find_or_create_by!(name: cat[:name])
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
    category_name: "ケーキ・洋菓子",
    name: "プレミアムロールケーキ",
    manufacturer: "ローソン"
  },
  {
    category_name: "アイス・冷菓",
    name: "雪見だいふく",
    manufacturer: "ロッテ"
  },
  {
    category_name: "飲み物",
    name: "午後の紅茶 ミルクティー",
    manufacturer: "キリン"
  },
  {
    category_name: "ドーナツ",
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
