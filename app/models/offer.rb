class Offer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :a, type: Integer, as: :dollar_amount    
  field :z, type: Boolean, as: :cancelled, :default => false    
  field :b, type: Integer, as: :hour_amount  
  field :c, type: Integer, as: :cleaner_amount  
  #field :d, type: Time, as: :date         
  #field :e, type: String, as: :time      	
      


  belongs_to :profile
  belongs_to :job

	attr_accessor :stripe_card_token

	validates_presence_of :profile_id, :job_id, :dollar_amount
	
end
