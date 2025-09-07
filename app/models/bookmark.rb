class Bookmark < ApplicationRecord
  validates :user_id, uniqueness: { scope: :product_id }

  belongs_to :user
  belongs_to :product
end
