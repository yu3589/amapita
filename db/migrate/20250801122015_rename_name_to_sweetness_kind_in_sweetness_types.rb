class RenameNameToSweetnessKindInSweetnessTypes < ActiveRecord::Migration[7.2]
  def change
    rename_column :sweetness_types, :name, :sweetness_kind
  end
end
