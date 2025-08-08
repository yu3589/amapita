class Post < ApplicationRecord
  validates :product_name, presence: true, length: { maximum: 25 }
  validates :manufacturer, presence: true
  validates :category_id, presence: true
  validates :sweetness_rating, presence: true
  validates :post_sweetness_score, presence: true

  belongs_to :user
  belongs_to :category

  has_one_attached :image
  has_one :post_sweetness_score, dependent: :destroy
  accepts_nested_attributes_for :post_sweetness_score

  enum sweetness_rating: {
    lack_of_sweetness: 0,
    could_be_sweeter: 1,
    perfect_sweetness: 2,
    slightly_too_sweet: 3,
    too_sweet: 4
  }
end
