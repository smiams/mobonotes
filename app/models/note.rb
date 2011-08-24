class Note < ActiveRecord::Base  
  validates :content, :presence => true

  attr_accessible :content  
end