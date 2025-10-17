class AddUserIdToProducts < ActiveRecord::Migration[7.2]
  def change
    add_reference :products, :user, null: true, foreign_key: true

    if User.exists?
      Product.where(user_id: nil).update_all(user_id: User.first.id)
    end

    change_column_null :products, :user_id, false
  end
end
