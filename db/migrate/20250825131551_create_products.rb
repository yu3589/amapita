class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.string :manufacturer, null: false

      t.timestamps
    end

    add_index :products, [ :name, :manufacturer ], unique: true
  end
end
