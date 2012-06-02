class Note < ActiveRecord::Base  
  belongs_to :label
  belongs_to :user
  belongs_to :task

  validates :content, :presence => true
  validates :user, :presence => true

  attr_accessible :content

  scope :created_between, lambda { |start_time, end_time| where(:created_at => start_time..end_time) }
end