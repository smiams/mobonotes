require 'spec_helper'

describe Label do
  before(:each) do
    @label = Factory(:label)
    @label.valid?.should == true
  end
  
  it "should require a name" do
    @label.name = ""
    @label.valid?.should == false
    @label.errors[:name].first.should == "can't be blank"
  end
  
  it "should require a user" do
    @label.user_id = ""
    @label.valid?.should == false
    @label.errors[:user_id].first.should == "can't be blank"
  end
end