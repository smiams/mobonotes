class Label < ActiveRecord::Base
  belongs_to :user
  has_many :notes
  has_many :tasks

  validates :name, :presence => true

  attr_accessible :name

  def self.with_current_tasks_for_user(user, start_time, end_time)
    start_time_utc_db = start_time.utc.to_formatted_s(:db)
    end_time_utc_db = end_time.utc.to_formatted_s(:db)

    self.where(
      "labels.user_id = ?
      AND (((tasks.end_at IS NOT NULL
      AND tasks.start_at IS NOT NULL
      AND tasks.start_at <= ? AND tasks.end_at >= ?)
      OR (tasks.end_at IS NULL AND tasks.start_at BETWEEN ? AND ? AND tasks.completed_at IS NULL))
      OR (tasks.start_at <= ? AND tasks.rolling = true AND tasks.completed_at IS NULL)
      OR (tasks.completed_at BETWEEN ? AND ?))",
      user.id,
      end_time_utc_db, start_time_utc_db,
      start_time_utc_db, end_time_utc_db,
      end_time_utc_db,
      start_time_utc_db, end_time_utc_db
    ).eager_load({:tasks => :notes}, :user)
  end
end