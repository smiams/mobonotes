module Authentication
  require 'bcrypt'
  
  def self.included(included_class)
    included_class.send(:include, ActiveModel::Validations)
    included_class.send(:attr_accessor, :password_required)
    included_class.send(:validates, :password, 
                                    :confirmation => {:message => "Password and password confirmation need to match.", :if => :password_changed?},
                                    :length => {:within => 4..32, :if => Proc.new { |object| object.password_required || object.password_changed? }})
    
    begin
      has_columns = included_class.respond_to?(:column_names)
      included_class.send(:attr_accessor, :password_hash) unless has_columns && included_class.column_names.map(&:to_sym).include?(:password_hash)
    rescue Exception => e
      included_class.logger.error e.to_s
    end
  end
    
  def password_changed?
    !self.password.nil? && self.password != ''
  end

  # # Create password via BCrypt; set the password_hash attribute unless the password is nil or empty
  # # => If you want to set the password_hash to nil, then you have to do this: user.update_attribute(:password_hash, nil)
  def password=(new_password)
    self.password_hash = BCrypt::Password.create(new_password) if !new_password.nil? && new_password != ''
    @password = new_password
  end
  
  # # This method will error out if there is an attempt to set the password_hash to an invalid hash format (i.e. 'simplepassword')
  def password_hash=(password_hash)
    super(BCrypt::Password.new(password_hash))
  end
  
  # # If self.password has been explicitly set on this object, then return it; 
  # # Otherwise generate a new BCrypt::Password object and return it;
  # # If there is an error with the BCrypt::Password.new(self.password_hash) (i.e. when a form-builder runs @user.password and it's a new User object with no passowrd), then catch the error and return nil
  def password
    @password
  end
  
  # # Authenticate the user against a password and an account; 
  # # TODO: WORK THIS OUT -> auth_params must contain 2 keys: (1) :account => account_object (2) :password => password_string
  def authenticate(password)
    # Call BCrypt::Password's "==" method to check the authenticity of the password
    if BCrypt::Password.new(self.password_hash) == password
      return true
    else
      self.errors.add(:authentication, "Incorrect E-Mail/Password combination.")

      self.password = ''
      self.password_confirmation = ''

      return false
    end
  end
end