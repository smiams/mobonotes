class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :label
  has_many :notes

  validates :name, :presence => true
  validates :user, :presence => true

  attr_accessible :name

  def mark_complete
    self.completed_at = Time.now
    self.save
  end

  def mark_incomplete
    self.completed_at = nil
    self.save
  end

  def complete?
    self.completed_at.present?
  end
end