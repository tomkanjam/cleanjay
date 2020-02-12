class ProfilesController < ApplicationController
  #before_filter :authorize, :except => [:show, :city_page, :city_search]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  def city_search
    if params[:city] == nil
      redirect_to "/", :notice => "Please enter a city"
    else
      redirect_to "/c/#{params[:city]}"
    end
  end

  def city_page
    @city = City.where(url: params[:url]).first
    if @city == nil
      redirect_to "/"
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
      
      @form_desitnation = "/calculate-city-rates"
      @city_name = @city.pretty_name
      @title = "Cleaning Services " + @city.pretty_name + " | CleanJay"
      @meta_description = "The easiest way to find an awesome cleaning service in " + @city.pretty_name
      @profiles = Profile.all.where(city_id: @city.id, p: true)
			@profile_count = @profiles.count
	    @cleaning_type = "maintenance"
		  
    end
  end

  def calculate_city_rates
    @city = City.where(url: params[:city]).first
    @profiles = @city.profiles.where(p: true)
		@profile_count = @profiles.count
		calculate_rates(params)
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end
  
  def calculate_profile_rates
		calculate_rates(params)
    respond_to do |format|
      format.json { render json: @profile }
    end
  end
  
  def calculate_rates(params)
		session[:bedrooms] = params[:bedrooms].to_f
		session[:bathrooms] = params[:bathrooms].to_f
		
	  params[:fridge] ? session[:fridge] = true : session[:fridge] = false
	  params[:oven] ? session[:oven] = true : session[:oven] = false 
	  params[:cabinets] ? session[:cabinets] = true : session[:cabinets] = false 
	  params[:windows] ? session[:windows] = true : session[:windows] = false
	  params[:walls] ? session[:walls] = true : session[:walls] = false
	  
	  case params[:cleaning_type] 
	  when "maintenance"
	    @cleaning_type = "maintenance"
	    cleaning_type_hours = 0
	  when "onetime"
	    @cleaning_type = "onetime"
	    cleaning_type_hours = 0
	  when "move"
	    @cleaning_type = "move"
	    cleaning_type_hours = 1
	  when "construction"
	    @cleaning_type = "construction"
	    cleaning_type_hours = 1
	  end
	  
		calculated_hours = (BASE_HOURS.to_f + params[:bedrooms].to_f + 
		  params[:bathrooms].to_f + 
		  (FRIDGE_HOURS if session[:fridge]).to_f + 
		  (OVEN_HOURS if session[:oven]).to_f + 
		  (CABINETS_HOURS if session[:cabinets]).to_f + 
		  (WINDOWS_HOURS if session[:windows]).to_f + 
		  (WALLS_HOURS if session[:walls]).to_f + 
		  cleaning_type_hours.to_f)
		  
		p "============="
		p params[:total_hours]
		p calculated_hours
		
		if params[:total_hours] != calculated_hours 
		  @hours = params[:total_hours].to_f 
		else
		  @hours = calculated_hours.to_f
		end
		  
		session[:total_hours] = @hours
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find_by(url: params[:url])
    if @profile.p      
      #if @profile.website != nil
        #@website = @profile.website.match("http://") == nil ? "http://" + @profile.website : @profile.website
      #end
      @name = @profile.name 
      
      @title = "Cleaning Services " + @profile.city.pretty_name + " | " + @name
      @meta_description = @name + " | " + @profile.about[0..140]
      
      @form_desitnation = "/calculate-profile-rates"
			@profile_id = @profile._id
			@hourly_rate = @profile.hourly_rate
			@rating = nil
			@price = @hourly_rate * session[:total_hours] if session[:total_hours]
      @neighbourhoods = @profile.neighbourhoods
      @about = @profile.about 
      @thumb = @profile.image.thumb
		  @total_hours = session[:total_hours]
		  @bonded = @profile.bonded
		  @licensed = @profile.licensed
		  @insured = @profile.insured

      @profile.inc(:v, 1)
    else
      redirect_to("/c/#{@profile.city.url}/home-cleaners")
    end
    
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = Profile.new
    @cities = City.all
		@hourly_rate = HOURLY_RATE_RANGE
		@min_hours = MIN_BOOKABLE_HOURS

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
    @cities = City.all
		@hourly_rate = HOURLY_RATE_RANGE
		@min_hours = MIN_BOOKABLE_HOURS
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = current_user.profiles.build(params[:profile])
    @profile.claim_id = rand(36**7...36**50).to_s(36)
    @profile.url = @profile.name.parameterize
    @profile.notification_email = current_user.email
    @cities = City.all

    respond_to do |format|
      if @profile.save
        if current_user.role == "seller"
          #create_cleaner_account_confirmation(current_user)
          format.html { redirect_to "/dashboard/bookings", notice: 'Profile was successfully created.' }
          format.json { render json: @profile, status: :created, location: @profile }
        else
          format.html { redirect_to "/ehdmin/show_profiles/#{@profile.city.url}", notice: '' }
        end
      else
				@cities = City.all
				@hourly_rate = (15..35).to_a
				@min_hours = (1..3).to_a
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])
    @cities = City.all

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        if current_user.role == "seller"
          format.html { redirect_to "/dashboard/profile", notice: 'Profile was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to "/ehdmin/show_profiles/#{@profile.city.url}", notice: '' }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :no_content }
    end
  end

end
