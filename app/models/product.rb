class Product < ApplicationRecord
  include ImageValidatable
  has_one_attached :image

  RAKUTEN_URL_PATTERN = /\Ahttps:\/\/item\.rakuten\.co\.jp\/[\w\-\/]+\z/

  validates :name, presence: true, length: { maximum: 40 }
  validates :manufacturer, presence: { message: :select }
  validates :name, uniqueness: { scope: :manufacturer, message: :name_manufacturer_taken }
  validates :category_id, presence: { message: :select }
  validates :product_url, format: { with: RAKUTEN_URL_PATTERN, allow_blank: true, message: :blank }

  belongs_to :category, optional: true
  has_many :posts, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

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

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "manufacturer" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category", "posts" ]
  end
end
