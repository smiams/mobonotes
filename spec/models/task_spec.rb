require '../spec_helper'

describe Task do
  context "new tasks" do
    before(:each) do
      @task = Task.new
    end

    it "defaults start_at to the current time" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task = create(:task, :user => create(:user))
        @task.start_at.should == Time.now
      end
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
          @user = create(:user)
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

  describe "#created_between" do
    it "should return the correct notes" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        user = create(:user)

        task_1 = create(:task, :created_at => Time.now - 1.day, :user => user)
        task_2 = create(:task, :created_at => Time.now - 1.second, :user => user)
        task_3 = create(:task, :created_at => Time.now + 0.seconds, :user => user)
        task_4 = create(:task, :created_at => Time.now + 1.second, :user => user)

        tasks = Task.created_between(Time.now - 1.day, Time.now)

        tasks.should == [task_1, task_2, task_3]
      end
    end
  end

  describe "#completed_between" do
    it "should return the correct notes" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        user = create(:user)

        task_1 = create(:task, :completed_at => Time.now - 1.day, :user => user)
        task_2 = create(:task, :completed_at => Time.now - 1.second, :user => user)
        task_3 = create(:task, :completed_at => Time.now + 0.seconds, :user => user)
        task_4 = create(:task, :completed_at => Time.now + 1.second, :user => user)

        tasks = Task.completed_between(Time.now - 1.day, Time.now)

        tasks.should == [task_1, task_2, task_3]
      end
    end
  end

  describe "#irrelevant_between" do
    it "should return the correct notes" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        user = create(:user)

        task_1 = create(:task, :irrelevant_at => Time.now - 1.day, :user => user)
        task_2 = create(:task, :irrelevant_at => Time.now - 1.second, :user => user)
        task_3 = create(:task, :irrelevant_at => Time.now + 0.seconds, :user => user)
        task_4 = create(:task, :irrelevant_at => Time.now + 1.second, :user => user)

        tasks = Task.irrelevant_between(Time.now - 1.day, Time.now)

        tasks.should == [task_1, task_2, task_3]
      end
    end
  end

  describe "#relevant" do
    it "should only return relevant tasks" do
      user = create(:user)

      task_1 = create(:task, :irrelevant_at => Time.now - 1.day, :user => user)
      task_2 = create(:task, :irrelevant_at => Time.now - 1.second, :user => user)
      task_3 = create(:task, :user => user)

      tasks = Task.relevant.should == [task_3]
    end
  end

  describe "#relevant?" do
    it "should true for a relevant task" do
      user = create(:user)
      task = create(:task, :irrelevant_at => nil, :user => user)
      task.relevant?.should == true
    end

    it "should false for an irrelevant task" do
      user = create(:user)
      task = create(:task, :irrelevant_at => Time.now, :user => user)
      task.relevant?.should == false
    end
  end

  describe "#irrelevant!" do
    it "should set the Task's irrelevant_at attribute to the current time" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        user = create(:user)
        task = create(:task, :irrelevant_at => nil, :user => user)

        task.irrelevant!

        task.reload.irrelevant_at.should == Time.now
      end
    end
  end

  describe "#relevant!" do
    it "should set the Task's irrelevant_at attribute to nil" do
      user = create(:user)
      task = create(:task, :irrelevant_at => Time.now, :user => user)

      task.relevant!

      task.reload.irrelevant_at.should == nil
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
      expect {
        @task.update_attributes(:created_at => Time.now)
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)

      @task.created_at.should == nil
    end
  end

  context "with a label" do
    before(:each) do
      @task = build(:task)
      @task.user = create(:user)
      @task.save
      @label = create(:label)
    end

    it "has a label" do
      @task.label = @label
      @task.save
      @task.reload.label.should == @label
    end
  end

  describe "#complete!" do
    before(:each) do
      @task = create(:task, :user => create(:user))
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
        @task = create(:task, :user => create(:user), :completed_at => Time.now)
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
      @task = create(:task, :user => create(:user))
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
      @task = create(:task, :user => create(:user), :started_at => Time.now)
    end

    it "sets the started_at timestamp to the current date/time" do
      @task.unstart!
      @task.reload.started_at.should == nil
    end
  end

  describe "#started?" do
    before(:each) do
      @task = create(:task, :user => create(:user), :started_at => Time.now)
    end

    it "returns true if the task has been started" do
      @task.started?.should == true
    end

    it "returns false if the task has not been started" do
      @task.started_at = nil
      @task.started?.should == false
    end
  end

  describe "#occurs_between" do
    before(:each) do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task = create(:task, :user => create(:user), :start_at => Time.now)
      end
    end

    context "without an end time" do
      it "is returned if it occurs within the time window" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          Task.occurs_between(Time.now, Time.now + 1.second).length.should == 1
        end
      end

      it "is not returned if it occurs outside the time window (left)" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          Task.occurs_between(Time.now + 1.second, Time.now + 1.seconds).length.should == 0
        end
      end

      it "is not returned if it occurs outside the time window (right)" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          Task.occurs_between(Time.now - 1.second, Time.now - 1.second).length.should == 0
        end
      end
    end

    context "with an end time" do
      before(:each) do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          @task.end_at = Time.now + 1.second
          @task.save
        end
      end

      it "is returned if it occurs within the time window (right)" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          Task.occurs_between(Time.now - 1.second, Time.now).length.should == 1
        end
      end

      it "is returned if it occurs within the time window (middle)" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          Task.occurs_between(Time.now, Time.now + 1.second).length.should == 1
        end
      end

      it "is returned if it occurs within the time window (left)" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          Task.occurs_between(Time.now + 1.second, Time.now + 2.seconds).length.should == 1
        end
      end
    end
  end

  describe "#occurs_before" do
    before(:each) do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @task = create(:task, :user => create(:user), :start_at => Time.now)
      end
    end

    it "is returned if it starts before the specified time" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        Task.occurs_before(Time.now + 1.second).length.should == 1
      end
    end

    it "is not returned if it starts after the specified time" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        Task.occurs_before(Time.now - 1.second).length.should == 0 
      end
    end
  end

  describe "complete and incomplete scopes" do
    before(:each) do
      @task_1 = create(:task, :user => create(:user))
      @task_2 = create(:task, :user => create(:user))
      @task_3 = create(:task, :user => create(:user), :completed_at => Time.now)
      @task_4 = create(:task, :user => create(:user), :completed_at => Time.now)
    end

    it "returns incomplete tasks" do
      incomplete_tasks = Task.incomplete

      incomplete_tasks.length.should == 2

      incomplete_task_ids = incomplete_tasks.map(&:id)

      incomplete_task_ids.should include(@task_1.id)
      incomplete_task_ids.should include(@task_2.id)
    end

    it "returns complete tasks" do
      complete_tasks = Task.complete

      complete_tasks.length.should == 2

      complete_task_ids = complete_tasks.map(&:id)

      complete_task_ids.should include(@task_3.id)
      complete_task_ids.should include(@task_4.id)
    end
  end

  describe "rolling scope" do
    before(:each) do
      @task_1 = create(:task, :user => create(:user), :rolling => true)
      @task_2 = create(:task, :user => create(:user))
      @task_3 = create(:task, :user => create(:user))
    end

    it "returns rolling tasks" do
      rolling_tasks = Task.rolling

      rolling_tasks.length.should == 1
      rolling_tasks.last.id.should == @task_1.id
    end

    it "does not return non-rolling tasks" do
      non_rolling_tasks = Task.non_rolling

      non_rolling_tasks.length.should == 2

      non_rolling_task_ids = non_rolling_tasks.map(&:id)

      non_rolling_task_ids.should include(@task_2.id)
      non_rolling_task_ids.should include(@task_3.id)
    end
  end
end