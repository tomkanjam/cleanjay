class City
  include Mongoid::Document
  include Mongoid::Timestamps

  field :a, type: String, as: :address    
  field :b, type: String, as: :url
  field :c, type: String, as: :pretty_name
  field :d, type: String, as: :site_name
  field :e, type: Boolean, as: :published, :default => false  

	has_many :profiles
	has_many :jobs
 
end
