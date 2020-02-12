class SessionsController < ApplicationController
  def new
    @title = "CleanJay Login | The easiest way to find an awesome cleaning service in your city"
    @meta_description = "CleanJay Login | The easiest way to find an awesome cleaning service in your city"
  end
  
  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

			if params[:profile_id]
				if current_user.buyer?
					redirect_to("/new-booking/#{params[:profile_id]}")
				else
					if current_user.profiles.count == 0
						redirect_to("/profiles/new")
					else
						redirect_to("/dashboard/bookings")
					end
				end
			else
				if user.role == "ehdmin"
					redirect_to("/ehdmin/home")
				elsif user.role == "contractor"
					redirect_to("/ehdmin/profiles")
				elsif current_user.profiles.count == 0
					redirect_to("/profiles/new")
				else
					redirect_to("/dashboard/bookings")
				end
			end

    else
      flash.now.alert = "Email or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
