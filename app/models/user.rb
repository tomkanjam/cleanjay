class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
 
  field :a, type: String, as: :role              # Role: ehdmin, seller, buyer
	field :b, type: String, as: :last_name 
	field :c, type: String, as: :phone 
	field :d, type: String, as: :first_name
	field :e, type: String, as: :stripe_access_token, :default => nil
  field :f, type: String, as: :email
	field :g, type: String, as: :name
  field :password_digest, :type => String
  
  has_secure_password

  attr_accessible :email, :password, :first_name, :last_name, :phone, :access_token, :name

  validates_uniqueness_of :email
  validates_presence_of :email, :role, :phone, :first_name, :last_name

  has_many :profiles
  has_many :jobs
	
	scope :seller, where(role: "seller")
	scope :buyer, where(role: "buyer")
	
	def buyer?
		self.role == "buyer"
	end

	def seller?
		self.role == "seller"
	end
end
