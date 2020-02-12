class Job
  include Mongoid::Document
  include Mongoid::Timestamps

  field :a, type: String, as: :address    
  field :b, type: String, as: :rate			  # Cleaner hourly rate at time of booking
  field :c, type: String, as: :postal_code    
  field :d, type: Time, as: :date         
  field :e, type: String, as: :email      
  field :f, type: String, as: :details    
  field :g, type: String, as: :name    		# Buyers's name
  field :h, type: String, as: :time      	
  field :i, type: String, as: :square_footage  
  field :j, type: Integer, as: :hours    
  field :k, type: Boolean, as: :cancelled, :default => false     
  field :l, type: String, as: :public_id     
  field :m, type: Integer, as: :bedrooms     
  field :n, type: Integer, as: :bathrooms     
  field :o, type: Boolean, as: :fridge, :default => false     
  field :p, type: String, as: :phone      
  field :q, type: Boolean, as: :oven, :default => false  
  field :r, type: Boolean, as: :cabinets, :default => false  
  field :s, type: String, as: :status, :default => "pending"     
  field :t, type: Boolean, as: :windows, :default => false  
  field :u, type: Boolean, as: :walls, :default => false  
  field :v, type: String, as: :cleaning_type, :default =>  "recurring"
  field :w, type: String, as: :building_type      
  field :x, type: Array, as: :offer_profiles, :default => []    
  field :y, type: String, as: :winning_profile_id, :default => nil
  field :z, type: String, as: :winning_offer_id, :default => nil
  field :aa, type: Boolean, as: :cancelled_by_buyer, :default => false     
  field :ab, type: Boolean, as: :cancelled_by_seller, :default => false    
  field :ac, type: Boolean, as: :confirmed_by_buyer, :default => false     
  field :ad, type: Boolean, as: :confirmed_by_seller, :default => false     
      

	index "public_id" => 1

  belongs_to :city
  belongs_to :profile
  belongs_to :user
  has_many :offers

	attr_accessor :stripe_card_token

	validates_presence_of :postal_code, :details ,:date ,:time, :email, :bedrooms , :bathrooms, :city_id#, :user_id

  def winning_offer
    self.winning_offer_id ? Offer.find(self.winning_offer_id) : nil
  end
  
  def winning_profile
    self.winning_offer_id ? Offer.find(self.winning_offer_id).profile : nil
  end
	
end


#e = email
#p = phone
#a = address
#c = postal code
#t = type - 0, 1, 2
#s = size - 1apt, 2house, 3 hours
#d = datetime
#c = comment, additional info
