class RemoveOldColumnsFromPosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :posts, :product_name, :string
    remove_column :posts, :manufacturer, :string
    remove_reference :posts, :category, foreign_key: true
  end
end
