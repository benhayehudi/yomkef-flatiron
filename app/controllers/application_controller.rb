require './config/environment'
require "./app/models/user"
require "./app/models/listing"

set :database, "sqlite3:./db/development.sqlite3"

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "yomkef_bitachon"
  end

  get "/" do
    erb :index
  end

  get "/about" do
    erb :about
  end

  get "/contact" do
    erb :contact
  end

  get "/registrations/signup" do
    erb :'/registrations/signup'
  end

  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == "" || params[:email] !~ (/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
      redirect '/registrations/signup'
    else
      @user = User.new(name: params["name"], username: params["username"], email: params["email"], password: params["password"])
      if @user.save
        session[:user_id] = @user.id
        redirect '/users/user_update'
      else
        redirect '/registrations/signup'
      end
    end
  end

  get "/users/user_update" do
    if logged_in?
      erb :"/users/user_update"
    else
      redirect '/login'
    end
  end

  post "/user_update" do
    if logged_in?
      current_user.update_attributes(:name => params["name"], :username => params["username"], :email => params["email"], :facebook_url => params["facebook_url"], :twitter_url => params["twitter_url"], :instagram_url => params["instagram_url"], :about_me => params["about_me"])
      current_user.save
      redirect to "/users/user_main"
    else
      redirect to "/login"
    end
  end

  post "/update-pw" do
    if logged_in?
      current_user.authenticate(params[:old_password])
      current_user.update_attribute(:password, params[:new_password])
      if current_user.password == params[:old_password] && !params[:new_password].empty?
        current_user.save
        redirect to "/users/user_main"
      end
    else
      redirect to "/users/user_update"
    end
  end

  get "/users/user_main" do
    @lists = Listing.find_by(:submitted_by => params[:submitted_by])
    erb :'/users/user_main'
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/users/user_main'
    else
      redirect '/login'
    end
  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def facebook_url?
      if current_user.facebook_url == nil
        "Facebook Link"
      else
        current_user.facebook_url
      end
    end

    def twitter_url?
      if current_user.twitter_url == nil
        "Twitter Link"
      else
        current_user.twitter_url
      end
    end

    def instagram_url?
      if current_user.instagram_url == nil
        "Instagram Link"
      else
        current_user.instagram_url
      end
    end

    def about_me?
      if current_user.about_me == nil
        "About Me"
      else
        current_user.about_me
      end
    end
  end
end
