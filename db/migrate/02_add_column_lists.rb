class AddColumnLists < ActiveRecord::Migration

  def change
    add_column :listings, :item_category, :string
  end
end
