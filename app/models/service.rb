class Service
  include Mongoid::Document

  field :a, :type => Boolean, :as => :active                          # Active
  field :n, :type => String, :as => :name                             # Name
  field :o, :type => String, :as => :phone                            # Phone
  

  embedded_in :profile

end

