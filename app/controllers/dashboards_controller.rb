class DashboardsController < ApplicationController
	before_filter :authorize, :has_profile?

  def bookings
	  @profile = current_user.profiles.first
		@jobs = @profile.city.jobs.where(:date.gt => Time.now, :cancelled.ne => true, :confirmed_by_buyer => false).order_by(:date.desc, :created_at.desc)
		@won_jobs = Job.all.where(:date.gt => Time.now - 24.hours, :cancelled.ne => true, :confirmed_by_buyer => true, :winning_profile_id => @profile.id).order_by(:date.desc)
		@job_count = @jobs.count
		@won_job_count = @won_jobs.count
    @offers = @profile.offers.where(:cancelled.ne => true)
    @offer_count = @offers.count
  end

  def my_bookings
	  @profile = current_user.profiles.first
		@jobs = @profile.city.jobs.where(:date.gt => Time.now, :cancelled.ne => true, :confirmed_by_buyer => false).order_by(:date.desc)
		@won_jobs = Job.all.where(:date.gt => Time.now - 24.hours, :cancelled.ne => true, :confirmed_by_buyer => true, :winning_profile_id => @profile.id).order_by(:date.desc)
		@job_count = @jobs.count
		@won_job_count = @won_jobs.count
    @offers = @profile.offers.where(:cancelled.ne => true)
    @offer_count = @offers.count
  end
  
  def create_offer
    offer = Offer.new(params[:offer])
    job = offer.job
    if offer.save
      #job.update_attributes(confirmed_by_seller: true)
      job.push(:offer_profiles, offer.profile.id)
      begin
        JobMailer.new_offer_alert_buyer(job).deliver
      end
      redirect_to "/dashboard/bookings", notice: 'Offer sent successfully.' and return  
    else
      redirect_to "/dashboard/bookings", notice: 'There was a problem with creating the offer.' and return 
    end     
  end
  
  def update_offer
    offer = Offer.find(params[:offer][:offer_id])
    if offer.update_attributes(params[:offer])
      redirect_to "/dashboard/bookings", notice: 'Updated offer sent successfully.' and return  
    else
      redirect_to "/dashboard/bookings", notice: 'There was a problem with updating the offer.' and return 
    end     
  end
  
  def cancel_offer
    offer = Offer.find(params[:offer][:offer_id])
    offer.cancelled = true
    
    if offer.update_attributes(params[:offer])
      a = offer.job.offer_profiles
      a.delete(offer.profile.id)
      offer.job.update_attributes(:offer_profiles => a)
      redirect_to "/dashboard/bookings", notice: 'Offer cancelled successfully.' and return  
    else
      redirect_to "/dashboard/bookings", notice: 'There was a problem with cancelling the offer.' and return 
    end     
  end
  
  def cancel_booking
    offer = Offer.find(params[:offer][:offer_id])
    offer.cancelled = true
    
    if offer.update_attributes(params[:offer])
      a = offer.job.offer_profiles
      a.delete(offer.profile.id)
      offer.job.update_attributes(:offer_profiles => a)
      redirect_to "/dashboard/bookings", notice: 'Offer cancelled successfully.' and return  
    else
      redirect_to "/dashboard/bookings", notice: 'There was a problem with cancelling the offer.' and return 
    end     
  end

	def account
    @profile = current_user.profiles.first
		@user = current_user
	end

	def profile
    @profile = current_user.profiles.first
		@user = current_user

    @cities = City.all
		@hourly_rate = HOURLY_RATE_RANGE.map {|h| "$" + h.to_s + "/hour"}
		@min_hours = MIN_BOOKABLE_HOURS.map {|h| h.to_s + " hours minimum"}
	end
	
	def settings
		if current_user.stripe_access_token == nil
			@token = false
		else
			@token = true
		end
	end

	def stripe3
    @profile = current_user.profiles.first
		p @profile
		@business_name = "#{current_user.first_name} #{current_user.last_name}"
		@business_type = "sole_prop"
		@phone_number = current_user.phone
		@url = "http://cleanzap.com/p/" + @profile.id
		@email = current_user.email
		@first_name = current_user.first_name
		@last_name = current_user.last_name
		@physical_product = "false"
		@product_category = "professional_services"		
	end

  def stripe_setup
    if params[:code]
			code = params[:code]
			client = OAuth2::Client.new(STRIPE_CLIENT_ID, STRIPE_API_KEY, :site => 'https://connect.stripe.com')
			@resp = client.auth_code.get_token(code, :params => {:scope => 'read_write'})
    	@access_token = @resp.token
			current_user.set(:stripe_access_token, @access_token)
			redirect_to user_root_path, :notice => "You have connected your Stripe account successfully!"
		end
  end

  def publish
    @profile = current_user.profiles.first
    if (@profile.image.to_s != "")
      @profile.update_attributes(p: true)
      redirect_to "/dashboard/overview", notice: 'Profile published successfully.'
    else
      redirect_to "/dashboard/overview", notice: 'Profile NOT published. Please ad a profile image.'
    end
  end

  def unpublish
    @profile = current_user.profiles.first
    @profile.update_attributes(p: false)
    redirect_to "/dashboard/overview", notice: 'Profile unpublished successfully.'
  end
  
  private
    
      def has_profile?
        if current_user.profiles.count == 0 && current_user.seller?
          redirect_to "/profiles/new"
        end
      end
end
