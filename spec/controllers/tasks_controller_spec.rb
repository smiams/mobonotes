require 'spec_helper'

describe TasksController do
  before(:all) do
    @current_user = Factory(:user)
    request.env["HTTP_REFERER"] = Rails.application.routes.generate :controller => "notes", :action => "index"
  end
  
  after(:all) do
    @current_user.destroy
  end

  before(:each) do
    @controller.instance_variable_set(:@current_user, @current_user)
    @controller.stub!(:get_current_user).and_return(true)
  end

  describe "POST create" do
    before(:each) do
      request.env["HTTP_REFERER"] = Rails.application.routes.generate :controller => "notes", :action => "index"
    end
    
    it "creates a new task" do
      expect {
        post :create, :task => {:name => "This is a new task."}
      }.to change {Task.count}.from(0).to(1)
      
      response.should redirect_to request.env["HTTP_REFERER"]
    end
    
    it "returns an error if it could not create the task" do
      expect {
        post :create, :gibberish => "This is just some gibberish."
      }.to_not change{Task.count}
      
      response.should render_template("new")
    end
    
    it "creates a new task with a label" do
      @label = Factory(:label)
      
      expect {
        post :create, :task => {:name => "This is a new task with a label.", :label_id => @label.id}
      }.to change {Task.count}.from(0).to(1)
      
      assigns(:task).label.should == @label
      response.should redirect_to notes_path
    end
    
    it "does not create a new task for another user" do
      pending
    end
  end
  
  describe "PUT complete" do
    before(:each) do      
      @task = Factory(:task, :user => @current_user)
    end
        
    it "completes the task" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        put :complete, :id => @task.id
        @task.reload.completed_at.should == Time.now
      end
    end
    
    it "does not complete the task if the current user does not own it" do
      pending
    end
  end
end
