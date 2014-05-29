require 'spec_helper'

describe TasksController, :type => :controller do
  before(:all) do
    @current_user = create(:user)
  end
  
  after(:all) do
    @current_user.destroy
  end

  before(:each) do
    @controller.instance_variable_set(:@current_user, @current_user)
    @controller.stub(:get_current_user).and_return(true)
  end

  describe "POST create" do
    before(:each) do
      request.env["HTTP_REFERER"] = "http://test.mobonotes/test"
    end
    
    it "creates a new task" do
      expect {
        post :create, :task => {:name => "This is a new task."}
      }.to change {Task.count}.by(+1)

      response.should redirect_to request.referrer
    end
    
    it "returns an error if it could not create the task" do
      expect {
        post :create, :gibberish => "This is just some gibberish."
      }.to_not change{Task.count}
      
      response.should render_template("new")
    end
    
    it "creates a new task with a label" do
      @label = create(:label)
      
      expect {
        post :create, :task => {:name => "This is a new task with a label.", :label_id => @label.id}
      }.to change {Task.count}.by(+1)
      
      assigns(:task).label.should == @label
      response.should redirect_to request.referrer
    end
    
    it "does not create a new task for another user" do
      pending
    end
  end
  
  describe "PUT complete" do
    before(:each) do
      @task = create(:task, :user => @current_user)
    end

    it "completes the task" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        put :complete, :id => @task.id, :format => :js
        @task.reload.completed_at.should == Time.now
      end
    end

    it "does not complete the task if the current user does not own it" do
      pending
    end
  end
  
  describe "PUT uncomplete" do
    before(:each) do
      @task = create(:task, :user => @current_user, :completed_at => STANDARD_FROZEN_TIME)
    end

    it "uncompletes the task" do
      put :uncomplete, :id => @task.id, :format => :js
      @task.reload.completed_at.should == nil
    end

    it "does not uncomplete the task if the current user does not own it" do
      pending
    end
  end

  describe "PUT start" do
    before(:each) do
      @task = create(:task, :user => @current_user)
    end

    it "starts the task" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        put :start, :id => @task.id, :format => :js
        @task.reload.started_at.should == Time.now
      end
    end
  end

  describe "PUT unstart" do
    before(:each) do
      @task = create(:task, :user => @current_user, :started_at => STANDARD_FROZEN_TIME)
    end

    it "unstarts the task" do
      put :unstart, :id => @task.id, :format => :js
      @task.reload.started_at.should == nil
    end
  end
end
