class Product < ApplicationRecord
  validates :name, presence: true, length: { maximum: 40 }
  validates :manufacturer, presence: true
  validates :name, uniqueness: { scope: :manufacturer, message: "とメーカーの組み合わせは既に存在します" }


  belongs_to :category
  has_many :posts, dependent: :destroy
  has_one_attached :image
end
