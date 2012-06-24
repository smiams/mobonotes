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
  
  context "created between" do
    it "should return the correct notes" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        user = Factory.create(:user)
        task_1 = FactoryGirl.create(:task, :created_at => Time.now - 1.day, :user => user)
        task_2 = FactoryGirl.create(:task, :created_at => Time.now - 1.second, :user => user)
        task_3 = FactoryGirl.create(:task, :created_at => Time.now + 0.seconds, :user => user)
        task_4 = FactoryGirl.create(:task, :created_at => Time.now + 1.second, :user => user)
        
        tasks = Task.created_between(Time.now - 1.day, Time.now)

        tasks.should == [task_1, task_2, task_3]
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
  
  describe "#complete!" do
    before(:each) do
      @task = Factory(:task, :user => Factory(:user))
    end
    
    it "sets the completed_at date/time to the current date/time" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task.complete!
        @task.reload.completed_at.should == Time.now
      end
    end
    
    it "returns false if it does not save" do
      @task.should_receive(:save).and_return(false)

      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task.complete!.should == false
        @task.reload.completed_at.should == nil
      end      
    end
  end

  describe "#uncomplete!" do
    before(:each) do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task = Factory(:task, :user => Factory(:user), :completed_at => Time.now)
      end
    end

    it "sets the completed_at date/time to nil" do
      @task.uncomplete!
      @task.reload.completed_at.should == nil
    end

    it "returns false if it does not save" do
      @task.should_receive(:save).and_return(false)

      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task.uncomplete!.should == false
        @task.reload.completed_at.should == Time.now
      end
    end
  end

  describe "#start!" do
    before(:each) do
      @task = Factory(:task, :user => Factory(:user))
    end

    it "sets the started_at timestamp to the current date/time" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task.start!
        @task.reload.started_at.should == Time.now
      end
    end
  end

  describe "#unstart!" do
    before(:each) do
      @task = Factory(:task, :user => Factory(:user), :started_at => Time.now)
    end

    it "sets the started_at timestamp to the current date/time" do
      @task.unstart!
      @task.reload.started_at.should == nil
    end
  end

  describe "#started?" do
    before(:each) do
      @task = Factory(:task, :user => Factory(:user), :started_at => Time.now)
    end

    it "returns true if the task has been started" do
      @task.started?.should == true
    end

    it "returns false if the task has not been started" do
      @task.started_at = nil
      @task.started?.should == false
    end
  end
end