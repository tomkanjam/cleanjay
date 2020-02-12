class JobsController < ApplicationController
	before_filter :authorize, :except => [:new, :create, :thank_you]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])
		@profile = @job.profile

		@job_date = @job.date.strftime("%A, %B %e, ") + @job.time
		@job_hours = @job.hours
		@job.apartment == nil ? apartment = "" : apartment = ", Apt. " + @job.apartment.to_s
		@job_location = @job.address.to_s + apartment + ", " + @job.city.to_s + ", " + @job.postal_code.to_s
		@job_details = @job.details
		@job_name = @job.name
		@job_phone = @job.phone
		@job_email = @job.email
		@job_status = @job.status
		@job_extras = "#{'fridge' if @job.fridge} #{'oven' if @job.oven} #{'cabinets' if @job.cabinets} #{'walls' if @job.walls} #{'windows' if @job.windows }"
		@job_extras.parameterize == "" ? nil : @job_extras = "Extras: " + @job_extras
		(@job_extras.parameterize == "" && @job_details == "") ? @show_box_content = false : @show_box_content = true
		

    @name = @profile.name 
		@hourly_rate = 15
		@rating = nil   
    #@heading = @profile.heading   
    @neighbourhoods = @profile.neighbourhoods
    @about = @profile.about 
    @thumb = @profile.image.thumb

		if current_user
			current_user.buyer? ? @show_sidebar = true : @show_sidebar = false
		end
			

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job = Job.new
    @profile = Profile.find(params[:id])
		@profile_id = @profile.id
    #@heading = @profile.heading
    @name = @profile.name
		@hours = params[:h]
		@rating = nil   
    @neighbourhoods = @profile.neighbourhoods
    @thumb = @profile.image.thumb
		@id = @profile.id
		@rate = @profile.hourly_rate
  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.json
  def create    
    @job = Job.new(params[:job])
		@job.public_id = rand(36**7...36**8).to_s(36)
		
    if @job.save
      JobMailer.new_booking_alert_buyer(@job).deliver
      JobMailer.admin_alert(@job.attributes, "New Booking").deliver
      @job.city.profiles.where(:approved => true).each do |p|
        JobMailer.new_booking_alert_seller(@job, p.notification_email).deliver
      end
      #redirect_to booking_path(@job.public_id), notice: 'job was successfully created.'
      redirect_to("/my-booking/#{@job.public_id}")
    else
      render action: "new"
    end
    
  end
  
  def thank_you
    job = Job.find(params[:id])
    @cleaner_name = job.profile.name
  end
  
  def confirm_booking
    job = Job.find(params[:id])
    profile = job.profile
    @seller_name = profile.name
    @bedrooms = job.bedrooms
    @bathrooms = job.bathrooms
    @fridge = job.fridge
    @oven = job.oven
    @cabinets = job.cabinets
    @windows = job.windows
    @walls = job.walls
    #@cleaning_date = 
    @hours = job.hours
  end

  def buyer_confirm_booking
    @job = Job.find(params[:job_id])
    @job.confirmed_by_buyer = true
    @job.name = params[:name]
    @job.address = params[:address]
    @job.phone = params[:phone]
    @job.winning_profile_id = params[:winning_profile_id]
    @job.winning_offer_id = params[:winning_offer_id]
    
    respond_to do |format|
      if @job.save
        JobMailer.confirmed_booking_alert_seller(@job).deliver
        JobMailer.confirmed_booking_alert_buyer(@job).deliver
        format.html { redirect_to "/my-booking/#{@job.public_id}", notice: 'Booking was successfully cancelled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/my-booking/#{@job.public_id}", notice: 'There was a problem with cancelling your booking' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def buyer_cancel_booking
    @job = Job.find(params[:id])
    @job.cancelled_by_buyer = true
    @job.cancelled = true

    respond_to do |format|
      if @job.update_attributes(params[:job])
        JobMailer.cancelled_booking_alert_seller(@job, "the customer").deliver
        JobMailer.cancelled_booking_alert_buyer(@job, "you").deliver
        format.html { redirect_to "/my-booking/#{@job.public_id}", notice: 'Booking was successfully cancelled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/my-booking/#{@job.public_id}", notice: 'There was a problem with cancelling your booking' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def  seller_cancel_booking
    offer = Offer.find(params[:offer][:offer_id])
    @job = offer.job
    @job.cancelled_by_seller = true
    @job.cancelled = true
    a = @job.offer_profiles
    a.delete(offer.profile.id)
    @job.offer_profiles = a

    respond_to do |format|
      if @job.update_attributes(params[:job])    
        offer.update_attributes(:cancelled => true)
        JobMailer.cancelled_booking_alert_seller(@job, "you").deliver
        JobMailer.cancelled_booking_alert_buyer(@job, "the cleaner").deliver
        format.html { redirect_to "/dashboard/my-bookings}", notice: 'Booking was successfully cancelled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/dashboard/my-bookings", notice: 'There was a problem with cancelling your booking' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to "/my-booking/#{@job.public_id}", notice: 'job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to "/my-booking/#{@job.public_id}", notice: 'Job was not saved.' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end
end
