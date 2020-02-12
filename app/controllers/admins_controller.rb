class AdminsController < ApplicationController

  #before_filter :require_admin

  def home
    
  end
  
  def bookings
    @jobs = Job.all.order_by(:date.desc)
  end
  
  def posts
    @posts = Post.all
    @post = Post.new
  end
  
  def edit_post
    @posts = Post.all
    @post = Post.all.where(title: params[:title]).first
  end

  def cities
    @cities = City.all
    @city = City.new
  end

  def edit_city
    @cities = City.all
    @city = City.all.where(url: params[:city]).first
  end
  
  def edit_user
    @users = User.all
    if params[:id] == "all"
      @user = User.all.first
    else
      @user = User.find_by(id: params[:id])
    end
  end
  
  def profiles
    @cities = City.all
  end

  def show_profiles
    @cities = City.all
    @city = City.all.where(url: params[:city]).first
    @profiles = @city.profiles.order_by(:created_at.asc)
    @profile = Profile.new
		@hourly_rate = HOURLY_RATE_RANGE
		@min_hours = MIN_BOOKABLE_HOURS
  end
  
  def edit_profile
    @cities = City.all
    @profile = Profile.find(params[:id])
    @city = @profile.city
    @profiles = @city.profiles.order_by(:created_at.asc)
		@hourly_rate = HOURLY_RATE_RANGE
		@min_hours = MIN_BOOKABLE_HOURS
  end
 
  private
 
  def require_admin
    if current_user.role != "ehdmin"
      flash[:error] = "You must be logged in to access this section"
      redirect_to "/" 
    end
  end
end
