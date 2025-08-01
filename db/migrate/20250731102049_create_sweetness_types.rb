class CreateSweetnessTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :sweetness_types do |t|
      t.integer :name

      t.timestamps
    end
  end
end
