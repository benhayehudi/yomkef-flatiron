class Listing < ActiveRecord::Base
  belongs_to :users

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true

  def self.my_listings(user_id)
    @listings = Listing.all.find{|user| user.user_id == user_id}
  end

  def self.search(search)
    Listing.where(Listing.arel_table[:user_id::text].matches("%#{search}%"))
  end
end
