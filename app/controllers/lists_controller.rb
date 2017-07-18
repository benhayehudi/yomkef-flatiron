require "pry"

class ListsController < ApplicationController

  get "/listings" do
    erb :'/listings/index'
  end

  get "/listings/new" do
    if logged_in?
      @user = current_user
      erb :'/listings/new'
    else
      redirect to "/login"
    end
  end

  post "/listings/new" do
    if logged_in?
        @listing = Listing.new(name: params["name"], location: params["location"], url: params["url"], img_url: params["img_url"], item_category: params["item_category"], description: params["description"], user_id: params["user_id"])
        if @listing.save
          redirect '/listings'
        else
          redirect to "/login"
      end
    end
  end

  get '/search-listings' do
    erb :'/listings/search-listings'
  end

  get '/listings/new/:id' do
    if logged_in?
      user_id = current_user
      listing = Listing.find_by_id(params[:id])
      @new_listing = Listing.new(name: listing.name, location: listing.location, url: listing.url, img_url: listing.img_url, item_category: listing.item_category, description: listing.description, user_id: user_id)
      if @new_listing.save
        redirect '/users/user_main'
      else
        redirect to "/login"
        end
      end
    end

  get '/listings/update/:id' do
    @listing = Listing.find_by_id(params[:id])
    if logged_in?
      @listing = Listing.find_by_id(params[:id])
      erb :'/listings/update'
    else
      redirect to "/login"
    end
  end

  post '/listings/update/:id' do
    if logged_in?
      @listing = Listing.find_by_id(params[:id])
      @listing.update_attributes(name: params["name"], location: params["location"], url: params["url"], img_url: params["img_url"], item_category: params["item_category"], description: params["description"])
      @listing.save
      redirect '/listings'
    else
      redirect to "/login"
    end
  end

  get '/listings/show/:id' do
    @listing = Listing.find_by_id(params[:id])
    erb :'/listings/show'
  end
end
