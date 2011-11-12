require 'spec_helper'

describe Task do
  context "new tasks" do
    before(:each) do
      @task = Task.new
    end
    
    context "without a name" do
      it "should be invalid" do
        @task.valid?.should == false
        @task.errors[:name].first.should == "can't be blank"
      end
    end
    
    context "with name" do
      before(:each) do
        @task.name = "This is a new task."
      end
      
      context "and without a user" do
        it "should be invalid" do
          @task.valid?.should == false
          @task.errors[:user].first.should == "can't be blank"
        end
      end

      context "and with a user" do
        before(:each) do
          @user = Factory(:user)
          @task.user = @user
        end
        
        it "should be valid" do
          @task.valid?.should == true
        end
        
        it "should be created" do
          expect {
            @task.save.should == true
          }.to change {Task.count}.from(0).to(1)
        end
      end
    end
  end
  
  context "mass-assignment" do
    before(:each) do
      @task = Task.new    
    end
    
    it "allows mass-assignment of the name attribute" do
      @task.update_attributes(:name => "This is some mass-assigned name.")
      @task.name.should == "This is some mass-assigned name."
    end
    
    it "doesn't allow mass-assignment of the created_at attribute" do
      @task.update_attributes(:created_at => Time.now)
      @task.created_at.should == nil
    end
  end
  
  context "with a label" do
    before(:each) do
      @task = FactoryGirl.build(:task)
      @task.user = Factory(:user)
      @task.save
      @label = Factory(:label)
    end
    
    it "has a label" do
      @task.label = @label
      @task.save
      @task.reload.label.should == @label
    end
  end   
  
  describe "#mark_completed" do
    before(:each) do
      @task = Factory(:task, :user => Factory(:user))
    end
    
    it "sets the completed_at date/time to the current date/time" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task.mark_completed
        @task.reload.completed_at.should == Time.now
      end
    end
    
    it "returns false if it does not save" do
      @task.should_receive(:save).and_return(false)
      
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task.mark_completed.should == false
        @task.reload.completed_at.should == nil
      end      
    end
  end
end