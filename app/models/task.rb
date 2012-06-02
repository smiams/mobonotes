class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :label
  has_many :notes, :dependent => :destroy

  validates :name, :presence => true
  validates :user, :presence => true

  attr_accessible :name

  scope :created_between, lambda { |start_time, end_time| where(:created_at => start_time..end_time) }

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