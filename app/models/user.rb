require "#{Rails.root.to_s}/lib/authentication"

class User < ActiveRecord::Base
  include Authentication

  has_many :labels
  has_many :notes
  has_many :tasks

  validates :email_address, 
            :format => {:with => /\A[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+([.][A-Za-z0-9-]+)?){1,}\.[A-Za-z]{2,4}\Z/i,
                        :message => "please provide a valid e-mail address"}

  attr_accessible :email_address
end