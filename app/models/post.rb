class Post < ApplicationRecord
  validates :sweetness_rating, presence: true
  validates :post_sweetness_score, presence: true
  validate :image_type_and_size
  validates :review, length: { maximum: 500 }

  belongs_to :user
  belongs_to :product
  accepts_nested_attributes_for :product, update_only: true

  has_one_attached :image
  has_one :post_sweetness_score, dependent: :destroy
  accepts_nested_attributes_for :post_sweetness_score

  enum :sweetness_rating, {
    lack_of_sweetness: 0,
    could_be_sweeter: 1,
    perfect_sweetness: 2,
    slightly_too_sweet: 3,
    too_sweet: 4
  }

  private

  def image_type_and_size
    return unless image.attached?

    unless image.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:image, "はJPG・JPEG・PNG形式のファイルのみ対応しています")
    end

    if image.blob.byte_size > 5.megabytes
      errors.add(:image, "は5MB以下にしてください")
    end
  end
end
