class JobMailer < ActionMailer::Base
  default from: "Tom @ CleanJay <tom@cleanjay.ca>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.job_mailer.user_new_job.subject
  #
  
  def admin_alert(data, subject)
    #@claim_url = "http://www.cleanjay.ca/claim-booking/#{job.profile.claim_id}"
    @data = data
    sub = "[Admin Alert] " + subject.to_s

    mail(:to => "tom@cleanjay.ca", subject: sub)
  end
  
  def new_lead_alert_admin(job)
    #@claim_url = "http://www.cleanjay.ca/claim-booking/#{job.profile.claim_id}"
    @job = job

    mail(:to => "tom@cleanjay.ca", subject: "[Admin Alert]]New Booking Created")
  end
  
  def cancelled_booking_alert_seller(job, who)
		@date = job.date.strftime("%A, %B %e, ") + job.time
		#@hours = job.hours
		@postal_code = job.postal_code
		@who = who
		#@details = job.details
		#@phone = job.phone
		p job
		@extras = "#{'fridge' if job.fridge} #{'oven' if job.oven} #{'cabinets' if job.cabinets} #{'walls' if job.walls} #{'windows' if job.windows }"

    mail(:to => job.winning_profile.notification_email, subject: "CleanJay Booking For #{@date}")
  end
  
  def cancelled_booking_alert_buyer(job, who)
		@date = job.date.strftime("%A, %B %e, ") + job.time
		#@hours = job.hours
		@postal_code = job.postal_code
		@who = who
		#@details = job.details
		#@phone = job.phone
		@extras = "#{'fridge' if job.fridge} #{'oven' if job.oven} #{'cabinets' if job.cabinets} #{'walls' if job.walls} #{'windows' if job.windows }"

    mail(:to => job.email, subject: "CleanJay Booking For #{@date}")
  end
  
  def confirmed_booking_alert_buyer(job)
		@date = job.date.strftime("%A, %B %e, ") + job.time
		#@hours = job.hours
		#@details = job.details
		@phone = job.phone
		@name = job.name
		@address = job.address
		@postal_code = job.postal_code
		@seller_name = job.winning_profile.name
    @booking_link = "http://cleanjay.ca/my-booking/" + job.public_id

    mail(:to => job.email, subject: "CleanJay Booking For #{@date}")
  end
  
  def confirmed_booking_alert_seller(job)
		@date = job.date.strftime("%A, %B %e, ") + job.time
		#@hours = job.hours
		#@details = job.details
		@phone = job.phone
		@name = job.name
		@address = job.address
		@postal_code = job.postal_code
		@seller_name = job.winning_profile.name
    @my_bookings_link = "http://cleanjay.ca/dashboard/my-bookings"

    mail(:to => job.winning_profile.notification_email, subject: "CleanJay Booking For #{@date}")
  end
  
  def new_booking_buyer(job)
    @building_type = job.building_type
    @bedrooms = job.bedrooms
    @bathrooms = job.bathrooms
    @cleaning_type = job.cleaning_type
    @edit_link = "http://cleanjay.ca/my-booking/" + job.public_id
		@date = job.date.strftime("%A, %B %e, ") + job.time
		#@hours = job.hours
		@postal_code = job.postal_code
		#@details = job.details
		#@phone = job.phone
		@extras = "#{'fridge' if job.fridge} #{'oven' if job.oven} #{'cabinets' if job.cabinets} #{'walls' if job.walls} #{'windows' if job.windows }"

    mail(:to => job.email, subject: "CleanJay Booking For #{@date}")
  end

  def new_booking_alert_seller(job, email)
    @user_name = job.name
		@date = job.date.strftime("%A, %B %e, ") + job.time
    @bookings_link = "http://cleanjay.ca/dashboard/bookings"
		#@hours = job.hours
		@postal_code = job.postal_code
		#@details = job.details
		#@phone = job.phone
		@extras = "#{'fridge' if job.fridge} #{'oven' if job.oven} #{'cabinets' if job.cabinets} #{'walls' if job.walls} #{'windows' if job.windows }"

    mail(:to => email, subject: "CleanJay - New Booking For #{@date}")
  end

  def new_booking_alert_buyer(job)
    @user_name = job.name
		@date = job.date.strftime("%A, %B %e, ") + job.time
		@hours = job.hours
    @booking_link = "http://cleanjay.ca/my-booking/" + job.public_id
		#@details = job.details
		#@extras = "#{'fridge' if job.fridge} #{'oven' if job.oven} #{'cabinets' if job.cabinets} #{'walls' if job.walls} #{'windows' if job.windows }"

    mail(:to => job.email, subject: "CleanJay Booking For #{@date}")
  end
  
  def new_job_seller(job, cleaner_name)
    @cleaner_name = cleaner_name
    @user_name = job.name
		@date = job.date.strftime("%A, %B %e, ") + job.time
		@hours = job.hours
		@address = job.address
		@details = job.details
		@phone = job.phone
		@extras = "#{'fridge' if job.fridge} #{'oven' if job.oven} #{'cabinets' if job.cabinets} #{'walls' if job.walls} #{'windows' if job.windows }"

    mail(:to => job.profile.notification_email, subject: "New Booking For #{@date} [CleanJay]")
  end
  
  def new_offer_alert_buyer(job)
    @my_booking_link = "http://cleanjay.ca/my-booking/" + job.public_id
		@date = job.date.strftime("%A, %B %e, ") + job.time

    mail(:to => job.email, subject: "New CleanJay Offer For #{@date}")
  end
  
  def lead_contact_1(profile)
    @claim_url = "http://www.cleanjay.ca/claim-booking/#{job.profile.claim_id}"
    @cleaner_name = profile.name
    @city = profile.city.pretty_name

    mail(:to => job.profile.notification_email, subject: "New Booking For #{@date} [CleanJay]")
  end
end
