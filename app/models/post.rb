class Post < ApplicationRecord
  include ImageValidatable
  has_one_attached :image
  EDITABLE_HOURS = 24

  validates :sweetness_rating, presence: { message: :select }
  validates :post_sweetness_score, presence: true
  validates :review, length: { maximum: 500 }
  validates :status, presence: true

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

  enum status: { publish: 0, unpublish: 1 }

  scope :perfect_sweetness, -> { where(sweetness_rating: :perfect_sweetness) }
  scope :publish, -> { where(status: :publish) }

  def self.ransackable_attributes(auth_object = nil)
    [ "review", "created_at", "sweetness_rating" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "product", "user", "category" ]
  end

  def editable_product?
    return false if product.nil? || product.created_at.nil?
    return false if product.user != self.user

    Time.current - product.created_at <= EDITABLE_HOURS.hours
  end

  def share_url_with_cache_buster
    Rails.application.routes.url_helpers.post_url(self, v: updated_at.to_i)
  end

  def x_share_text
    return "" unless product&.name.present?
      "【#{product.name}】のあまピタ判定をしたよ！\n\n#あまピタッ\n#{share_url_with_cache_buster}"
  end
end
