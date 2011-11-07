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

  describe "_get_current_tab" do
    it "gets the current tab name out of the User's session" do
      session[:current_tab] = "tab-name-for-spec"
      controller.send(:_get_current_tab).should == "tab-name-for-spec"
      controller.instance_variable_get(:@current_tab).should == "tab-name-for-spec"
    end

    it "gets the default tab name if the User's session does not indicate the current tab name" do
      controller.send(:_get_current_tab).should == notes_path
      controller.instance_variable_get(:@current_tab).should == notes_path
    end
  end

  describe "set_current_tab" do
    it "sets the session's current_tab attribute to the specified tab name" do
      controller.set_current_tab("another-tab-name-for-spec")
      session[:current_tab].should == "another-tab-name-for-spec"
    end

    it "sets the current tab to the specfied tab name" do
      controller.set_current_tab("another-tab-name-for-spec")
      controller.instance_variable_get(:@current_tab).should == "another-tab-name-for-spec"
    end
  end
end