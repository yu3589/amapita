class AddSelfIntroductionToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :self_introduction, :string
  end
end
