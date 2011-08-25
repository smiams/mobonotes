require 'spec_helper'

describe ApplicationController do
  describe "get_current_user" do
    context "with a session[user_id]" do
      before(:each) do
        @user = Factory(:user, :password => "correct", :password_confirmation => "correct")        
      end

      it "gets the current user if that user exists in the database" do
        session[:user_id] = @user.id
        controller.get_current_user
        controller.instance_variable_get(:@current_user).id.should == @user.id
      end
    
      it "does not get the current user if the user doesn't exist in the database" do
        session[:user_id] = "something-random"
        controller.should_receive(:redirect_to).with(login_path).and_return(false)
        controller.send(:get_current_user)
        controller.instance_variable_get(:@current_user).should == nil
      end
    end
    
    context "without a session[user_id]" do
      it "does not get the user from the database and redirects back to the login page" do
        session[:user_id] = nil
        
        controller.should_receive(:redirect_to).with(login_path).and_return(false)
        controller.send(:get_current_user)
        controller.instance_variable_get(:@current_user).should == nil
      end
    end
  end
  
  describe "_set_time_zone" do
    it "sets the time zone to Central Time (US & Canada)" do
      controller.send(:_set_time_zone)
      Time.zone.to_s == "(GMT-06:00) Central Time (US & Canada)"
    end
  end
end