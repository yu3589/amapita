class AddSweetnessTypeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :sweetness_type, foreign_key: true
  end
end
