require 'spec_helper'

describe Label do
  describe "attribute validations" do
    before(:each) do
      @label = build(:label)
      @label.valid?.should == true
    end

    it "should require a name" do
      @label.name = ""
      @label.valid?.should == false
      @label.errors[:name].first.should == "can't be blank"
    end
  end

  describe "with_current_tasks_for_user" do
    before(:each) do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        @user_1 = create(:user)
        @user_2 = create(:user)

        @label_1 = create(:label_with_tasks_for_user, :user => @user_1)
        @label_2 = create(:label_with_tasks_for_user, :user => @user_1)
        @label_3 = create(:label_with_tasks_for_user, :user => @user_2)
      end
    end

    describe "returning labels with tasks for today" do
      before(:each) do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          @labels = Label.with_current_tasks_for_user(@user_1, Time.now.beginning_of_day, Time.now.end_of_day)
        end
      end

      it "returns a set of labels with current tasks for a specified user" do
        @labels.length.should == 2
      end

      it "returns a set of current tasks for each label" do
        @labels[0].tasks.length.should == 6
        @labels[1].tasks.length.should == 6
      end
    end

    describe "returning Labels with Tasks for yesterday" do
      before(:each) do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          @labels = Label.with_current_tasks_for_user(@user_1, Time.now.beginning_of_day - 1.day, Time.now.end_of_day - 1.day)
        end
      end

      it "returns a set of labels with yesterday's tasks for a specified user" do
        @labels.length.should == 2
      end

      it "returns a set of tasks from yesterday for each label" do
        @labels[0].tasks.length.should == 4
        @labels[1].tasks.length.should == 4
      end
    end
  end
end