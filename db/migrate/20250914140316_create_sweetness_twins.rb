class CreateSweetnessTwins < ActiveRecord::Migration[7.2]
  def change
    create_table :sweetness_twins do |t|
      t.references :user, null: false, foreign_key: true
      t.references :twin_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
