class Beta
  include Mongoid::Document

  field :a, type: String, as: :category
  field :b, type: String, as: :email  
end
