class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :label
  has_many :notes, :dependent => :destroy

  validates :name, :presence => true
  validates :user, :presence => true

  attr_accessible :name, :rolling

  scope :created_between, lambda { |start_time, end_time| where(:created_at => start_time..end_time) }
  scope :occurs_between, lambda { |start_time, end_time|
    start_time = start_time.utc.to_formatted_s(:db)
    end_time = end_time.utc.to_formatted_s(:db)

    where(
      "(end_at IS NOT NULL AND start_at IS NOT NULL AND start_at <= '#{end_time}' AND end_at >= '#{start_time}')
      OR (end_at IS NULL AND start_at BETWEEN '#{start_time}' AND '#{end_time}')"
    )
  }

  scope :occurs_before, lambda { |end_time|
    where("(start_at <= '#{end_time.utc.to_formatted_s(:db)}')")
  }

  scope :complete, where("completed_at IS NOT NULL")
  scope :incomplete, where("completed_at IS NULL")

  scope :rolling, where(:rolling => true)
  scope :non_rolling, where("rolling = false OR rolling IS NULL")

  before_create { self.start_at ||= Time.now }

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