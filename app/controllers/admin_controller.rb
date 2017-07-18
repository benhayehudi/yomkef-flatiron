class AdminController < ApplicationController

  get "/admin/admin-main" do
    if logged_in?
        if current_user.id == 1
          erb :'/admin/admin-main'
        else
          redirect to '/'
        end
      end
    end

  get "/admin/all-users" do
    if logged_in?
        if current_user.id == 1
          erb :'/admin/all-users'
        else
          redirect to '/'
        end
      end
    end

  get "/admin/all-listings" do
    if logged_in?
      if current_user.id == 1
        erb :'/admin/all-listings'
      else
        redirect to '/'
      end
    end
  end

  get "/admin/edit-listing/:id" do
    if logged_in?
      if current_user.id == 1
        @listing_entry = Listing.find_by_id(params[:id])
        @owner = User.find_by_id(@listing_entry.user_id)
        erb :'/admin/edit-listing'
      else
        redirect to '/'
      end
    end
  end

  post "/admin/edit-listing/:id" do
    if logged_in?
      if current_user.id == 1
        @listing_entry = Listing.find_by_id(params[:id])
        @listing_entry.update_attributes(name: params["name"], location: params["location"], url: params["url"], img_url: params["img_url"], item_category: params["item_category"], description: params["description"])
        @listing_entry.save
        redirect to "/admin/all-listings"
      else
        redirect to '/'
      end
    end
  end

  get "/admin/delete-listing/:id" do
    if logged_in?
      if current_user.id == 1
        listing_entry = Listing.find_by_id(params[:id])
        listing_entry.delete
        redirect to '/admin/all-listings'
      else
        redirect to '/'
      end
    end
  end

  get "/admin/edit-user/:id" do
    if logged_in?
      if current_user.id == 1
        @user_entry = User.find_by_id(params[:id])
        erb :'/admin/edit-user'
      else
        redirect to '/'
      end
    end
  end

  post "/admin/edit-user/:id" do
    if logged_in?
      if current_user.id == 1
        user_entry = User.find_by_id(params[:id])
        user_entry.update_attributes(:name => params["name"], :username => params["username"], :email => params["email"], :facebook_url => params["facebook_url"], :twitter_url => params["twitter_url"], :instagram_url => params["instagram_url"], :about_me => params["about_me"])
        user_entry.save
        redirect to "/admin/all-users"
      else
        redirect to '/'
      end
    end
  end

  get "/admin/delete-user/:id" do
    if logged_in?
      if current_user.id == 1
        user_entry = User.find_by_id(params[:id])
        user_entry.delete
        redirect to '/admin/all-users'
      else
        redirect to '/'
      end
    end
  end
end
