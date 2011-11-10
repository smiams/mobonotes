class Label < ActiveRecord::Base
  belongs_to :user
  has_many :notes
  has_many :tasks
  
  validates :user_id, :presence => true
  validates :name, :presence => true
  
  attr_accessible :name
end