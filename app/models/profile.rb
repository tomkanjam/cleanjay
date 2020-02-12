class Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :a, type: Integer, as: :hourly_rate, :default => 22     # Hourly rate
  field :b, type: String, as: :approved, :default => true      # Approved by adimn?
  field :c, type: Integer, as: :min_hours, :default => 2        # Job minimum number of hours
  field :d, type: String, as: :about                            # About service
  field :e, type: String, as: :notification_email               # Contact Email
  field :f, type: String, as: :summary                          # 
  field :g, type: String, as: :url                              # URL
  field :h, type: Boolean, as: :supplies                        # Cleaner provides cleaning supplies?
  #field :i, type: Boolean, as: :home                           # Home cleaner
  #field :j, type: Boolean, as: :commercial                     # Commercial cleaner
  #field :k, type: Boolean, as: :carpet                         # Carpet cleaner
  #field :l, type: Boolean, as: :upholstery                     # Upholstery cleaner
  #field :m, type: Boolean, as: :car                            # Car cleaner
  field :n, type: String, as: :name                             # Name
  field :o, type: String, as: :phone                            # Phone
  field :p, type: Boolean, as: :published, :default => true     # Published
  field :q, type: Boolean, as: :claimed, :default => true       # Claimed by seller?
  field :r, type: String, as: :claim_id                         # Claim ID
  #field :t, type: Integer                                      # Type
  #field :u, type: Boolean, as: :junk                           # Junk hauler
  #field :v, type: Integer, as: :views, :default => 0            # Views
  field :w, type: String, as: :note                             # Note
  field :z, type: String, as: :neighbourhoods                   # Neighbourhoods
  field :aa, type: Integer, as: :maintenance_rate, :default => 22     # Hourly rate
  field :ab, type: Integer, as: :onetime_rate, :default => 27     # Hourly rate
  field :ac, type: Integer, as: :move_rate, :default => 29     # Hourly rate
  field :ad, type: Integer, as: :construction_rate, :default => 29     # Hourly rate
  field :ae, type: String, as: :email  
  field :af, type: String, as: :email2  
  field :ag, type: String, as: :email3  
  #field :ah, type: Boolean, as: :licensed, :default => false       
  #field :ai, type: Boolean, as: :insured, :default => false       
  #field :aj, type: Boolean, as: :bonded, :default => false       
  

  belongs_to :user
  belongs_to :city

  has_many :jobs
  has_many :offers

  #embeds_many :services

  mount_uploader :image, ImageUploader  
	
	validates_presence_of :about, :name, :image, :notification_email, :city_id
  #validates :city_id, :h, :e, :d, :ps, :pm, :pv, :st, :presence => true
end

# Types
# 0 => Home Cleaners, Maids and Cleaning Services
# 1 => Business and Commercial Cleaners and Cleaning Services
# 2 => Carpet Cleaners
