require 'spec_helper'

describe SessionsController do
  describe "GET new" do    
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end  
  end
  
  describe "POST create" do
    before(:each) do
      @user = Factory(:user, :password => "correct", :password_confirmation => "correct")
    end
    
    context "with valid credentials" do
      before(:each) do
        post :create, {:session => {:email_address => "sean.iams@gmail.com", :password => "correct"}}
      end

      it "creates a new session" do
        session[:user_id].should == assigns(:user).id
      end
      
      it "redirects to the notes_path" do
        response.should redirect_to(notes_path)
      end
    end
    
    context "with invalid password credentials" do
      it "should not log the user in" do
        post :create, {:session => {:email_address => "sean.iams@gmail.com", :password => "not correct"}}
        
        response.should redirect_to(login_path)
        session[:user_id].should == nil
      end
    end
    
    context "with invalid email credentials" do
      it "should not log the user in" do
        post :create, {:session => {:email_address => "sean.iams-not-correct@gmail.com", :password => "correct"}}

        response.should redirect_to(login_path)
        session[:user_id].should == nil
      end
    end
  end
  
  describe "GET destroy" do
    before(:each) do
      user = Factory(:user, :password => "correct", :password_confirmation => "correct")
      session[:user_id] = user.id
    end
    
    it "destroys the session[:user_id]" do
      delete :destroy
      session[:user_id].should == nil
    end
    
    it "redirects back to the login page" do
      delete :destroy
      response.should redirect_to(login_path)
    end
  end
end