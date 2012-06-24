class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :label
  has_many :notes, :dependent => :destroy

  validates :name, :presence => true
  validates :user, :presence => true

  attr_accessible :name

  scope :created_between, lambda { |start_time, end_time| where(:created_at => start_time..end_time) }

  def complete!
    self.completed_at = Time.now
    self.save
  end

  def uncomplete!
    self.completed_at = nil
    self.save
  end

  def complete?
    self.completed_at.present?
  end

  def start!
    self.started_at = Time.now
    self.save
  end

  def unstart!
    self.started_at = nil
    self.save
  end

  def started?
    self.started_at.present?
  end

  def in_progress?
    self.started_at.present? && self.complete? == false
  end
end