class AddProductIdToPosts < ActiveRecord::Migration[7.2]
  def change
    add_reference :posts, :product, null: true, foreign_key: true
  end
end
