class AddRakutenFieldsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :rakuten_url, :string
    add_column :products, :rakuten_image_url, :string
  end
end
