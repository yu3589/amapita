class CreatePostSweetnessScores < ActiveRecord::Migration[7.2]
  def change
    create_table :post_sweetness_scores do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :sweetness_strength, null: false
      t.integer :aftertaste_clarity, null: false
      t.integer :natural_sweetness, null: false
      t.integer :coolness, null: false
      t.integer :richness, null: false

      t.timestamps
    end
  end
end
