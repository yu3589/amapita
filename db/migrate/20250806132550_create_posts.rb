class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :product_name, null: false
      t.string :manufacturer, null: false
      t.integer :sweetness_rating, null: false
      t.text :review, null: true

      t.timestamps
    end
  end
end
