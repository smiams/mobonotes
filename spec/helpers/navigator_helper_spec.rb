require 'spec_helper'

describe NavigatorHelper do
  before :all do
    @sft = STANDARD_FROZEN_TIME
  end

  describe "content_for_end_date" do
    it "is hidden when there is < 1 day difference between the start time and the end time" do
      helper.content_for_end_date(@sft, @sft).should == "<span id=\"end-date\" style=\"display: none;\"> - July 20, 2011</span>"
    end

    it "is displayed when there is 1+ day difference between the start time and the end time" do
      helper.content_for_end_date(@sft, @sft + 1.day).should == "<span id=\"end-date\" style=\"\"> - July 21, 2011</span>"
    end
  end

  describe "url_for_tab" do
    it "builds a tab url for a single date" do
      helper.url_for_tab("tasks", nil, @sft, @sft).should == "/tasks/dates/2011-07-20"
    end

    it "builds a tab url for a single date" do
      helper.url_for_tab("tasks", nil, @sft, @sft + 1.minute).should == "/tasks/dates/2011-07-20"
    end

    it "builds a tab url for a date range" do
      helper.url_for_tab("tasks", nil, @sft, @sft + 1.day).should == "/tasks/dates/2011-07-20/2011-07-21"
    end

    context "with a label" do
      before(:each) do
        @label = mock_model("Label", :id => "test-label-id", :name => "Test Label Name")
      end

      it "builds a tab url for a single date" do
        helper.url_for_tab("tasks", @label, @sft, @sft).should == "/labels/test-label-id/tasks/dates/2011-07-20"
      end

      it "builds a tab url for a single date" do
        helper.url_for_tab("tasks", @label, @sft, @sft + 1.minute).should == "/labels/test-label-id/tasks/dates/2011-07-20"
      end

      it "builds a tab url for a date range" do
        helper.url_for_tab("tasks", @label, @sft, @sft + 1.day).should == "/labels/test-label-id/tasks/dates/2011-07-20/2011-07-21"
      end      
    end

    it "throws an Argument Error when the specified tab is not a valid tab" do
      expect {
        helper.url_for_tab("invalid tab name", nil, @sft, @sft + 1.day)
      }.to raise_error(ArgumentError, "The tab \"invalid tab name\" has not been configured and is therefore invalid. Please check initializers.")
    end
  end

  describe "link_to_change_mode" do
    it "returns a link to choose a date range" do
      helper.link_to_change_mode(@sft, @sft).should == "<a id=\"change-mode\">choose a date range instead...</a>"
    end

    it "returns a link to choose a single date" do
      helper.link_to_change_mode(@sft, @sft + 1.day).should == "<a id=\"change-mode\">choose a single date instead...</a>"
    end    
  end

  describe "get_base_path" do
    before(:each) do
      assign(:current_tab, "tasks")
    end

    it "gets the current tab's base path when no label is present" do
      helper.get_base_path.should == "/tasks"
    end
    
    it "gets the current tab's base path when a label is present" do      
      assign(:label, mock_model("Label", :id => "test-label-id"))
      helper.get_base_path.should == "/labels/test-label-id/tasks"
    end
  end

  describe "get_label_options" do
    before(:each) do
      assign(:current_tab, "tasks")

      assign(:labels, [
        mock_model("Label", :id => "test-label-id-1", :name => "test label one"),
        mock_model("Label", :id => "test-label-id-2", :name => "test label two")
      ])
    end

    it "gets label options based on the current tab and a single date" do
      helper.get_label_options(@sft, @sft).should == [
        ["- All Labels -", "/tasks/dates/2011-07-20"],
        ["test label one", "/labels/test-label-id-1/tasks/dates/2011-07-20"],
        ["test label two", "/labels/test-label-id-2/tasks/dates/2011-07-20"]]
    end

    it "gets label options based on the current tab and a date range" do
      helper.get_label_options(@sft, @sft + 1.day).should == [
        ["- All Labels -", "/tasks/dates/2011-07-20/2011-07-21"],
        ["test label one", "/labels/test-label-id-1/tasks/dates/2011-07-20/2011-07-21"],
        ["test label two", "/labels/test-label-id-2/tasks/dates/2011-07-20/2011-07-21"]]
    end
  end

  describe "link_to_date_range_back" do
    before(:each) do
      assign(:current_tab, "tasks")
    end

    it "returns a link to navigate to the previous single date" do
      helper.link_to_date_range_back(nil, @sft, @sft).should == "<a href=\"/tasks/dates/2011-07-19\" id=\"back\">&laquo;</a>"
    end

    it "returns a link to navigate to the previous date range" do
      helper.link_to_date_range_back(nil, @sft, @sft + 1.day).should == "<a href=\"/tasks/dates/2011-07-18/2011-07-19\" id=\"back\">&laquo;</a>"
    end

    context "with a label" do
      before(:each) do
        @label = mock_model("Label", :id => "test-label-id", :name => "Test Label Name")
      end

      it "returns a link to navigate to the previous single date" do
        helper.link_to_date_range_back(@label, @sft, @sft).should == "<a href=\"/labels/test-label-id/tasks/dates/2011-07-19\" id=\"back\">&laquo;</a>"
      end

      it "returns a link to navigate to the previous date range" do
        helper.link_to_date_range_back(@label, @sft, @sft + 1.day).should == "<a href=\"/labels/test-label-id/tasks/dates/2011-07-18/2011-07-19\" id=\"back\">&laquo;</a>"
      end
    end
  end

  describe "link_to_date_range_forward" do
    before(:each) do
      assign(:current_tab, "tasks")
    end

    it "returns a link to navigate to the next single date" do
      helper.link_to_date_range_forward(nil, @sft, @sft).should == "<a href=\"/tasks/dates/2011-07-21\" id=\"forward\">&raquo;</a>"
    end

    it "returns a link to navigate to the next date range" do
      helper.link_to_date_range_forward(nil, @sft, @sft + 1.day).should == "<a href=\"/tasks/dates/2011-07-22/2011-07-23\" id=\"forward\">&raquo;</a>"
    end

    context "with a label" do
      before(:each) do
        @label = mock_model("Label", :id => "test-label-id", :name => "Test Label Name")
      end

      it "returns a link to navigate to the next single date" do
        helper.link_to_date_range_forward(@label, @sft, @sft).should == "<a href=\"/labels/test-label-id/tasks/dates/2011-07-21\" id=\"forward\">&raquo;</a>"
      end

      it "returns a link to navigate to the next date range" do
        helper.link_to_date_range_forward(@label, @sft, @sft + 1.day).should == "<a href=\"/labels/test-label-id/tasks/dates/2011-07-22/2011-07-23\" id=\"forward\">&raquo;</a>"
      end      
    end
  end

  describe "_calculate_day_range" do
    it "calculates the day range for two identical times" do
      helper.send(:_calculate_day_range, @sft, @sft).should == 1
    end

    it "calculates the day range for two different times on the same day" do
      helper.send(:_calculate_day_range, @sft, @sft + 20.minutes).should == 1
    end

    it "calculate the day range for two different times on consecutive days" do
      helper.send(:_calculate_day_range, @sft, @sft + 1.day).should == 2
    end
    
    it "calculates the day range for two different times spanning more than one day" do
      helper.send(:_calculate_day_range, @sft, @sft + 2.days).should == 3
    end
    
    it "throws an ArgumentError if the start_time is greater than the end_time" do
      expect {
        helper.send(:_calculate_day_range, @sft + 2.days, @sft)
      }.to raise_error(ArgumentError, "start_time must be before end_time")
    end
  end

  describe "_date_range_back_path" do
    before(:each) do
      assign(:current_tab, "tasks")
    end

    it "returns a path to a previous date range" do
      helper.send(:_date_range_back_path, nil, @sft, @sft + 1.day).should == "/tasks/dates/2011-07-18/2011-07-19"
    end

    it "returns a path to a previous date" do
      helper.send(:_date_range_back_path, nil, @sft, @sft).should == "/tasks/dates/2011-07-19"
    end

    context "with a label" do
      before(:each) do
        @label = mock_model("Label", :id => "test-label-id")
      end

      it "returns a path to a previous date range" do
        helper.send(:_date_range_back_path, @label, @sft, @sft + 1.day).should == "/labels/test-label-id/tasks/dates/2011-07-18/2011-07-19"
      end

      it "returns a path to a previous date" do
        helper.send(:_date_range_back_path, @label, @sft, @sft).should == "/labels/test-label-id/tasks/dates/2011-07-19"
      end
    end
  end
  
  describe "_date_range_forward_path" do
    before(:each) do
      assign(:current_tab, "tasks")
    end

    it "returns a path to a previous date range" do
      helper.send(:_date_range_forward_path, nil, @sft, @sft + 1.day).should == "/tasks/dates/2011-07-22/2011-07-23"
    end

    it "returns a path to a previous date" do
      helper.send(:_date_range_forward_path, nil, @sft, @sft).should == "/tasks/dates/2011-07-21"
    end

    context "with a label" do
      before(:each) do
        @label = mock_model("Label", :id => "test-label-id")
      end

      it "returns a path to a previous date range" do
        helper.send(:_date_range_forward_path, @label, @sft, @sft + 1.day).should == "/labels/test-label-id/tasks/dates/2011-07-22/2011-07-23"
      end

      it "returns a path to a previous date" do
        helper.send(:_date_range_forward_path, @label, @sft, @sft).should == "/labels/test-label-id/tasks/dates/2011-07-21"
      end
    end  
  end
  
  describe "_get_date_range_path_for_tab" do
    it "returns a date range path for a tab and label" do
      label = mock_model("Label", :id => "test-label-id")
      _get_date_range_path_for_tab("tasks", label, @sft, @sft + 1.day).should == "/labels/test-label-id/tasks/dates/2011-07-20/2011-07-21"
    end

    it "returns a date range path for a tab and no label" do      
      _get_date_range_path_for_tab("tasks", nil, @sft, @sft + 1.day).should == "/tasks/dates/2011-07-20/2011-07-21"
    end

    it "raises an ArgumentError if the specified tab is invalid" do
      expect {
        _get_date_range_path_for_tab("invalid tab name", nil, @sft, @sft)
      }.to raise_error(ArgumentError, "The tab \"invalid tab name\" has not been configured and is therefore invalid. Please check initializers.")
    end
  end

  describe "_get_date_path_for_tab" do
    it "returns a date path for a tab and label" do
      label = mock_model("Label", :id => "test-label")
      _get_date_path_for_tab("tasks", label, @sft).should == "/labels/test-label/tasks/dates/2011-07-20"
    end

    it "returns a date path for a tab and no label" do      
      _get_date_path_for_tab("tasks", nil, @sft).should == "/tasks/dates/2011-07-20"
    end

    it "raises an ArgumentError if the specified tab is invalid" do
      expect {
        _get_date_path_for_tab("invalid tab name", nil, @sft)
      }.to raise_error(ArgumentError, "The tab \"invalid tab name\" has not been configured and is therefore invalid. Please check initializers.")
    end    
  end
end