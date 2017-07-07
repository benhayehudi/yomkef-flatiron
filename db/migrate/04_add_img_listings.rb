class AddImgListings < ActiveRecord::Migration
  def change
    add_column :listings, :img_url, :string
  end
end
