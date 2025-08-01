class CreateSweetnessProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :sweetness_profiles do |t|
      t.references :user, foreign_key: true
      t.integer :sweetness_strength
      t.integer :aftertaste_clarity
      t.integer :natural_sweetness
      t.integer :coolness
      t.integer :richness

      t.timestamps
    end
  end
end
