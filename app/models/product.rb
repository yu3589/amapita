class Product < ApplicationRecord
  validates :name, presence: true, length: { maximum: 40 }
  validates :manufacturer, presence: true
  validates :name, uniqueness: { scope: :manufacturer, message: "とメーカーの組み合わせは既に存在します" }


  belongs_to :category
  has_many :posts, dependent: :destroy
  has_one_attached :image

  def total_posts
    posts.size
  end

  def perfect_sweetness_count
    posts.where(sweetness_rating: Post.sweetness_ratings[:perfect_sweetness]).size
  end
end
