class UsersController < ApplicationController
 before_filter :authorize, :only => [:update]

  def new
    @user = User.new
  end
    
  def claim_booking
    @user = User.new
    @claim_id = params[:claim_id]
  end

  def new_buyer
    @user = User.new
		@profile_id = params[:id]
  end

	def create_buyer
		@user = User.new(params[:user])
		@user.role = "buyer"
		
		if @user.save
			Notifier.delay.create_cleaner_account_confirmation(@user)
		  
	    session[:user_id] = @user.id
			if params[:profile_id]
				redirect_to("/new-booking/#{params[:profile_id]}")
			else
	    	redirect_to "/"
			end
	  else
	    render "new_buyer"
	  end
	end

  def create
    @user = User.new(params[:user])
		@user.role = "seller"
    p params[:user]
    p @user
  	if @user.save
  	  claimed = false
  	
  	  p params[:user][:claim_id]
  	
			# Claim profile for new user
		  if params[:user][:claim_id] != ""
		    profile = Profile.find_by(claim_id: params[:user][:claim_id])
		    if profile
		      profile.update_attributes(user_id: @user.id)
		      claimed = true
		    end
		  end
		  
			Notifier.delay.create_cleaner_account_confirmation(@user)
	    session[:user_id] = @user.id
	    
	    if claimed == true
	      redirect_to "/dashboard/bookings"
	    else
	      redirect_to "/profiles/new"
	    end
	  else
	    render "new"
	  end
    
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to "/dashboard/account", notice: 'Account was successfully updated.' 
    else
      render 'users/form' 
    end
  end

end
