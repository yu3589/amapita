class AddTokenToSweetnessProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :sweetness_profiles, :token, :string
    add_index :sweetness_profiles, :token, unique: true

    SweetnessProfile.reset_column_information
    SweetnessProfile.find_each do |profile|
      profile.update!(token: SecureRandom.uuid)
    end

    change_column_null :sweetness_profiles, :token, false
  end
end
