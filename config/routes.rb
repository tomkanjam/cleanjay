Maid::Application.routes.draw do


  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get "sessions/new"

  match '/my-booking/:id' => 'pages#my_booking'
  match '/offer-test' => 'pages#offer_test'

  match '/cleaning-services-toronto/:url' => 'profiles#show'
  match '/cleaning-services-vancouver/:url' => 'profiles#show'
  match '/cleaning-services-edmonton/:url' => 'profiles#show'
  match '/cleaning-services-calgary/:url' => 'profiles#show'
  
  match '/claim-booking/:claim_id' => 'users#claim_booking' 
  #match '/add-profile/:claim_id' => 'users#claim_booking' 
  
  match '/city_search' => 'profiles#city_search'
  match '/my_profiles' => 'profiles#index'
  match '/choosing-a-maid' => 'pages#choosing'
  match '/p/:id' => 'profiles#show'
  match '/new-booking/:id' => 'jobs#new'
  match '/bookings/:id' => 'jobs#show', :as => :booking
  match '/booking-login/:id' => 'users#new_buyer'
  match '/thank-you/:id' => 'jobs#thank_you'
  match '/new-seller' => 'users#new'
  match '/ehdmin/home' => 'admins#home'
  match '/ehdmin/cities' => 'admins#cities'
  match '/ehdmin/profiles' => 'admins#profiles'
  match '/ehdmin/posts' => 'admins#posts'
  match '/ehdmin/offers' => 'admins#offers'
  match '/ehdmin/bookings' => 'admins#bookings'
  match '/ehdmin/edit_post/:title' => 'admins#edit_post'
  match '/ehdmin/show_profiles/:city' => 'admins#show_profiles'
  match '/ehdmin/edit_profile/:id' => 'admins#edit_profile'
  match '/ehdmin/edit_city/:city' => 'admins#edit_city'
  match '/ehdmin/edit_user/:id' => 'admins#edit_user'
  match '/users/:id/create_buyer' => 'users#create_buyer'

  match '/dashboard/bookings' => 'dashboards#bookings', :as => :user_root
  match '/dashboard/my-offers' => 'dashboards#my_offers'
  match '/dashboard/my-bookings' => 'dashboards#my_bookings'
  match '/dashboard/account' => 'dashboards#account'
  match '/dashboard/settings' => 'dashboards#settings'
  match '/dashboard/profile' => 'dashboards#profile'
  match '/dashboard/stripe3' => 'dashboards#stripe3'
  match '/dashboard/create-offer' => 'dashboards#create_offer'
  match '/dashboard/cancel-offer' => 'dashboards#cancel_offer'
  match '/dashboard/update-offer' => 'dashboards#update_offer'
  match '/dashboard/stripe_setup' => 'dashboards#stripe_setup'
  
  match '/jobs/buyer-cancel-booking' => 'jobs#buyer_cancel_booking'
  match '/jobs/buyer-confirm-booking' => 'jobs#buyer_confirm_booking'
  match '/jobs/seller-cancel-booking' => 'jobs#seller_cancel_booking'
  match '/jobs/seller-confirm-booking' => 'jobs#seller_confirm_booking'
  
  match '/publish-profile' => 'dashboards#publish'
  match '/unpublish-profile' => 'dashboards#unpublish'
  #match '/show-profile' => 'dashboards#show_profile'
  match '/beta1' => 'users#new'
  match '/save-beta' => 'pages#save_beta'
  match '/save-notify' => 'pages#save_notify'
  #match 'user_root' => 'dashboards#overview'
  match '/calculate-city-rates' => 'profiles#calculate_city_rates'
  match '/calculate-profile-rates' => 'profiles#calculate_profile_rates'
	
  match '/blog' => 'posts#index'
  match '/blog/:title' => 'posts#show'

  resources :users
  resources :cities
  resources :sessions
  resources :profiles
  resources :dashboards 
  resources :jobs
  resources :betas
  resources :posts
  
  match ':url' => 'pages#city_page_mm'
  root :to => 'pages#home'

end
