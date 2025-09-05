class Category < ApplicationRecord
  validates :slug, presence: true, uniqueness: true

  has_many :posts, through: :products
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "products", "posts" ]
  end

  def to_param
    slug
  end
end
