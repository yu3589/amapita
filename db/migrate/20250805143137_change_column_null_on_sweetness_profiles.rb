class ChangeColumnNullOnSweetnessProfiles < ActiveRecord::Migration[7.2]
  def change
    change_column_null :sweetness_profiles, :user_id, true
  end
end
