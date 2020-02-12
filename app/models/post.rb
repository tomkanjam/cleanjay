class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, type: String
  field :body, type: String
  
  index "title" => 1
  
  validates_presence_of :title, :body
end
