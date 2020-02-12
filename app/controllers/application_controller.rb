class ApplicationController < ActionController::Base
  protect_from_forgery
  
  BASE_HOURS = 2.5
  HOURLY_RATE_RANGE = (15..50).to_a
  MIN_BOOKABLE_HOURS = (1..3).to_a
  
  FRIDGE_HOURS = (0.5).to_f
  OVEN_HOURS = 0.5
  CABINETS_HOURS = 1.0
  WINDOWS_HOURS = 1.0
  WALLS_HOURS = 1.0
  
  
  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def authorize
      redirect_to login_url, alert: "Not authorized" if current_user.nil?
    end
end
