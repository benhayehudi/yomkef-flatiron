class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :email
      t.string :password_digest
      t.text :about_me
      t.string :facebook_url
      t.string :twitter_url
      t.string :instagram_url
      t.timestamps
    end

    create_table :listings do |t|
      t.string :name
      t.string :location
      t.text :description
      t.string :url
      t.string :submitted_by
      t.timestamps
    end

    create_table :users_listings, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :listing, index: true
    end
  end
end
