class AddForeignKeysToSweetnessProfiles < ActiveRecord::Migration[7.2]
  def change
    add_reference :sweetness_profiles, :sweetness_type, null: false, foreign_key: true
  end
end
