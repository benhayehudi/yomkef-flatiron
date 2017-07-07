require './config/environment'
require "./app/models/user"
require "./app/models/listing"

set :database, "sqlite3:./db/development.sqlite3"


class ApplicationController < Sinatra::Base #open class

  configure do #open do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "yomkef_bitachon"
  end #close do

  get "/" do #open do
    erb :index
  end #close do

  get "/about" do
    erb :about
  end

  get "/contact" do
    erb :contact
  end

  get "/registrations/signup" do #open do
    erb :'/registrations/signup'
  end #close do

  post "/signup" do #open do
    if params[:username] == "" || params[:password] == "" || params[:email] == "" || params[:email] !~ (/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
    redirect '/registrations/signup'
    else
      @user = User.create(name: params["name"], username: params["username"], email: params["email"], password: params["password"])
      session[:user_id] = @user.id
      redirect '/users/user_update'
    end #close if
  end #close do

  get "/users/user_update" do #open do
    if logged_in?
      @user = current_user
      erb :"/users/user_update"
    else
      redirect '/login'
    end
  end

  post "/user_update" do #open do
  if logged_in?
    @user = current_user
    # @user.update_attributes(name: params[:name], username: params[:username], email: params[:email], facebook_url: params[:facebook_url], twitter_url: params[:twitter_url], instagram_url: params[:instagram_url], about_me: params[:about_me])
    @user.update_attributes(:name => params["name"], :username => params["username"], :email => params["email"], :facebook_url => params["facebook_url"], :twitter_url => params["twitter_url"], :instagram_url => params["instagram_url"], :about_me => params["about_me"])
    @user.save
    redirect to "/users/user_main"
  else
    redirect to "/login"
    end
  end #close do

  post "/update-pw" do #open do
    if logged_in?
      @user = current_user
      @user && @user.authenticate(params[:old_password])
      @user.update_attribute(:password, params[:new_password])
      unless @user.password != params[:old_password] && params[:new_password].nil? || params[:new_password].empty?
      @user.save
      redirect to "/users/user_main"
    else
      redirect to "/users/user_update"
    end #close if
  end #close unless
  end #close do

  get "/users/user_main" do #Open do
    @user = current_user
    @lists = Listing.find_by(:submitted_by => params[:submitted_by])
    erb :'/users/user_main'
  end #close do

  get "/login" do #open do
    erb :login
  end #close do

  post "/login" do #open do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
     session[:user_id] = @user.id
    flash[:notice] = "Welcome, #{@user.username}!"
     redirect '/users/user_main'
    else
     redirect '/sessions/login'
    end #close if
  end #close do


  get "/success" do #open do
    if logged_in? #open if
      erb :success
    else
      redirect "/login"
    end #close if
  end #close do

  get "/failure" do #open do
    erb :failure
  end #close do

  get "/logout" do #open do
    session.clear
    redirect "/"
  end #close do

  helpers do #open helpers do

    def logged_in? #ope def
      !!session[:user_id]
    end #end def

  def current_user #open def
    User.find(session[:user_id])
  end #close def

  def facebook_url? #open def
      if @user.facebook_url == nil #open if
        "Facebook Link"
      else
        @user.facebook_url
    end #close if
  end #close def

  def twitter_url? #open def
      if @user.twitter_url == nil #open if
        "Twitter Link"
      else
        @user.twitter_url
    end #close if
  end #close def

  def instagram_url? #open def
      if @user.instagram_url == nil #open if
        "Instagram Link"
      else
        @user.instagram_url
    end #close if
  end #close def

  def about_me? #open def
      if @user.about_me == nil #open if
        "About Me"
      else
        @user.about_me
        end #close if
      end #close def
    end #close helpers
  end #close class
