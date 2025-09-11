class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.string :name, null: false, index: true
      t.integer :badge_kind, null: false
      t.integer :threshold, index: true

      t.timestamps
    end
    add_index :badges, [ :badge_kind, :threshold ]
  end
end
