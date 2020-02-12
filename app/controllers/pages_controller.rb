class PagesController < ApplicationController
  #before_filter :authorize, only: [:home]
  
  def home
    @cities = City.where(published: true)
  end

  def beta1
    @beta = Beta.new
  end

  def home_beta
    @beta = Beta.new
  end

  def my_booking
    @job = Job.where(public_id: params[:id]).first
    if @job
      @offers = @job.offers.where(:cancelled.ne => true)
    else
      redirect_to "/", notice: ""
    end
  end
  
  def offer_test
    @job = Job.last
    @profiles = Profile.all
    
  end
  
  def city_page_mm
    @city = City.where(url: "cleaning-services-montreal").first
      if session[:total_hours]
        if session[:total_hours] >= BASE_HOURS 
          @hours = session[:total_hours]
        else
          session[:total_hours] = BASE_HOURS	
          @hours = BASE_HOURS
        end	  
      else
        session[:total_hours] = BASE_HOURS	
        @hours = BASE_HOURS
      end	  
      
      @job = @city.jobs.build
      @city_name = @city.pretty_name
      @city_id = @city.id
      @title = "Cleaning Services " + @city.pretty_name + " | CleanJay"
      @meta_description = "The easiest way to find an awesome cleaning service in " + @city.pretty_name
      #p @job		
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end
  
  def city_page
    @city = City.where(url: params[:url]).first
    if @city == nil
      redirect_to "/" and return
    else
      if session[:total_hours]
        if session[:total_hours] >= BASE_HOURS 
          @hours = session[:total_hours]
        else
          session[:total_hours] = BASE_HOURS	
          @hours = BASE_HOURS
        end	  
      else
        session[:total_hours] = BASE_HOURS	
        @hours = BASE_HOURS
      end	  
      
      @job = @city.jobs.build
      @city_name = @city.pretty_name
      @city_id = @city.id
      @title = "Cleaning Services " + @city.pretty_name + " | CleanJay"
      @meta_description = "The easiest way to find an awesome cleaning service in " + @city.pretty_name
      p @job		  
    end
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end

  def save_notify
    @beta = Beta.create(email: params[:email], category: "notify")
    redirect_to "/", notice: "Thanks for signing up. We'll email you shortly."
  end

  def save_beta
    @beta = Beta.create(email: params[:email], category: "beta")
    redirect_to "/", notice: "Thanks for signing up. We'll contact you shortly."
  end

  def choosing
  end
end
