class Category < ApplicationRecord
  has_many :posts, through: :products
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    [ "name" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "products", "posts" ]
  end
end
