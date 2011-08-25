require 'spec_helper'

describe User do
  context "new user" do
    before(:each) do
      @user = User.new
    end
    
    it "should be valid" do
      @user.email_address = "sean.iams@gmail.com"
      @user.valid?.should == true
    end
    
    context "who is invalid" do
      it "has no email address" do
        @user.valid?.should == false
        @user.errors[:email_address].first.should == "please provide a valid e-mail address"
      end

      it "has an invalid email address" do
        @user.email_address = "sean.iams@@gmail.com"
        
        @user.valid?.should == false
        @user.errors[:email_address].first.should == "please provide a valid e-mail address"
      end
    end
  end
  
  context "mass-assignment" do
    before(:each) do
      @user = User.new    
    end
    
    it "allows mass-assignment of the email_address attribute" do
      @user.update_attributes(:email_address => "sean.iams@gmail.com")
      @user.email_address.should == "sean.iams@gmail.com"
    end
    
    it "doesn't allow mass-assignment of the password_hash attribute" do
      @user.update_attributes(:password_hash => "test-password-hash")
      @user.password_hash.should == nil
    end
  end
  
  context "authentication" do
    before(:each) do
      @user = Factory(:user, :password => "new password", :password_confirmation => "new password")
    end
    
    it "should save password_hash to the database" do
      @user.reload.read_attribute(:password_hash).length.should > 0
    end
    
    it "should succeed authentication" do
      @user.reload.authenticate("new password").should == true
    end
    
    it "should fail authentication" do
      @user.reload.authenticate("different password").should == false
    end
  end
end