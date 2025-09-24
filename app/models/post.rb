class Post < ApplicationRecord
  include ImageValidatable
  has_one_attached :image

  validates :sweetness_rating, presence: { message: :select }
  validates :post_sweetness_score, presence: true
  validates :review, length: { maximum: 500 }

  belongs_to :user
  belongs_to :product
  has_one :category, through: :product
  has_one :post_sweetness_score, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :product, update_only: true
  accepts_nested_attributes_for :post_sweetness_score

  enum :sweetness_rating, {
    lack_of_sweetness: 0,
    could_be_sweeter: 1,
    perfect_sweetness: 2,
    slightly_too_sweet: 3,
    too_sweet: 4
  }

  scope :perfect_sweetness, -> { where(sweetness_rating: :perfect_sweetness) }

  def self.ransackable_attributes(auth_object = nil)
    [ "review", "created_at", "sweetness_rating" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "product", "user", "category" ]
  end
end
