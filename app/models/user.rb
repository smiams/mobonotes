class User < ActiveRecord::Base
  validates :email_address, 
            :format => {:with => /\A[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+([.][A-Za-z0-9-]+)?){1,}\.[A-Za-z]{2,4}\Z/i,
                        :message => "please provide a valid e-mail address"}
                        
  attr_accessible :email_address
end