class Note < ActiveRecord::Base  
  belongs_to :label
  belongs_to :user
  belongs_to :task

  validates :content, :presence => true
  validates :user, :presence => true

  attr_accessible :content
end