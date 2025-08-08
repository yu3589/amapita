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
