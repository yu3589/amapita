class ChangeProductIdNotNullInPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :product_id, false
  end
end
