class Note < ActiveRecord::Base  
  belongs_to :label
  
  validates :content, :presence => true
  
  attr_accessible :content
end