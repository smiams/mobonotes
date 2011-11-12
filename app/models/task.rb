class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :label

  validates :name, :presence => true
  validates :user, :presence => true
  
  attr_accessible :name
  
  def mark_completed
    self.completed_at = Time.now
    self.save
  end
end