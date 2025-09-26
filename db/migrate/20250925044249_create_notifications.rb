class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :notifiable, polymorphic: true, null: false
      t.integer :action, null: false
      t.boolean :checked, null: false, default: false

      t.timestamps
    end
    add_index :notifications, [ :recipient_id, :checked ]
  end
end
