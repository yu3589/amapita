class AddRakutenFieldsToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :product_url, :string
    add_column :products, :product_image_url, :string
  end
end
