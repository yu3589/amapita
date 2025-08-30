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

  def average_sweetness_scores
    scores = PostSweetnessScore.where(post_id: posts.select(:id))
    {
      sweetness_strength: scores.average(:sweetness_strength),
      aftertaste_clarity: scores.average(:aftertaste_clarity),
      natural_sweetness: scores.average(:natural_sweetness),
      coolness: scores.average(:coolness),
      richness: scores.average(:richness)
    }
  end
end
