class AddStatusToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :status, :integer

    Post.update_all(status: 0)

    change_column_null :posts, :status, false
  end
end
