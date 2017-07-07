class Listing < ActiveRecord::Base
  belongs_to :users

def self.my_listings(user_id)
  @listings = Listing.all.find{|user| user.user_id == user_id}
end

def self.search(search)
    Listing.where(Listing.arel_table[:user_id::text].matches("%#{search}%"))
end

end
