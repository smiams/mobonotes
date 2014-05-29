require 'spec_helper'

require "#{Rails.root.to_s}/lib/authentication"

class AuthenticatedModel
  include Authentication
end

describe Authentication do
  before(:each) do
    @authentication_spec = AuthenticatedModel.new
  end
  
  it "should have access to the password attribute" do
    @authentication_spec.password = "new password"
    @authentication_spec.password.should == "new password"
  end
  
  it "should know if its password did not change" do
    @authentication_spec.password_changed?.should == false
  end
  
  context "with validations" do
    it "should be invalid if the password and password_confirmation do not match" do
      @authentication_spec.password = "new password"
      @authentication_spec.password_confirmation = "different new password"

      @authentication_spec.valid?.should == false
      @authentication_spec.errors[:password_confirmation].first.should == "Password and password confirmation need to match."
    end
    
    it "should be valid if the password and password_confirmation match" do
      @authentication_spec.password = "new password"
      @authentication_spec.password_confirmation = "new password"

      @authentication_spec.valid?.should == true
    end
    
    it "should be valid if the password has not been updated, but still does not match the password_confirmation" do
      @authentication_spec.password = ""
      @authentication_spec.password_confirmation = "new password"

      @authentication_spec.valid?.should == true    
    end
    
    it "should be invalid if a password is required, but the password entered is too short" do
      @authentication_spec.password_required = true
      @authentication_spec.password = ""
      @authentication_spec.password_confirmation = ""

      @authentication_spec.valid?.should == false
      @authentication_spec.errors[:password].first.should == "is too short (minimum is 4 characters)"
    end
    
    it "should be invalid if the password is too short" do
      @authentication_spec.password = "sht"
      @authentication_spec.password_confirmation = "sht"

      @authentication_spec.valid?.should == false
      @authentication_spec.errors[:password].first.should == "is too short (minimum is 4 characters)"
    end
    
    it "should be invalid if the password is too long" do
      @authentication_spec.password = "lng"*30
      @authentication_spec.password_confirmation = "lng"*30

      @authentication_spec.valid?.should == false
      @authentication_spec.errors[:password].first.should == "is too long (maximum is 32 characters)"
    end
  end
  
  context "with a change to the password attribute" do
    before(:each) do
      @authentication_spec.password = "new password"
    end
    
    it "should know if its password changed" do
      @authentication_spec.password_changed?.should == true
    end
  
    it "should not register a change if the password was changed to nil" do
      @authentication_spec.password = nil
      @authentication_spec.password_changed?.should == false
    end
  
    it "should not register a change if the password was changed to ''" do
      @authentication_spec.password = ""
      @authentication_spec.password_changed?.should == false
    end
    
    it "should populate the password_hash attribute if the password is not blank" do
      @authentication_spec.password = "new password"
      @authentication_spec.password_hash.length.should > 0
    end
    
    it "should not populate the password_hash attribute if the password is blank" do
      @authentication_spec.password = ""
      @authentication_spec.password_hash == nil
    end
  end
  
  context "when authenticating an object" do
    before(:each) do
      @authentication_spec.password = "new password"
    end
    
    it "should succeed authentication if the password is correct" do
      @authentication_spec.authenticate("new password").should == true
    end
    
    it "should not succeed authentication if the password is incorrect" do
      @authentication_spec.authenticate("different new password").should == false
    end
    
    it "should put errors on the object when authentication fails" do
      @authentication_spec.authenticate("different new password").should == false
      @authentication_spec.errors[:authentication].first.should == "Incorrect E-Mail/Password combination."
    end
    
    it "should clear out the password and password_confirmation when authentication fails" do
      @authentication_spec.authenticate("different new password").should == false
      @authentication_spec.password.should == ""
      @authentication_spec.password_confirmation.should == ""
    end
  end
end