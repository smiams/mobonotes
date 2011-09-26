require 'spec_helper'

describe Note do
  context "new notes" do
    before(:each) do
      @note = Note.new
    end
    
    context "without content" do
      it "should be invalid" do
        @note.valid?.should == false
        @note.errors[:content].first.should == "can't be blank"
      end
    end
    
    context "with content" do
      before(:each) do
        @note.content = "This is a new note."
      end

      it "should be valid" do
        @note.valid?.should == true
      end
  
      it "should be creatd" do
        expect {
          @note.save.should == true
        }.to change {Note.count}.from(0).to(1)
      end
    end
  end
  
  context "mass-assignment" do
    before(:each) do
      @note = Note.new    
    end
    
    it "allows mass-assignment of the content attribute" do
      @note.update_attributes(:content => "This is some mass-assigned content.")
      @note.content.should == "This is some mass-assigned content."
    end
    
    it "doesn't allow mass-assignment of the created_at attribute" do
      @note.update_attributes(:created_at => Time.now)
      @note.created_at.should == nil
    end
  end
  
  context "with a label" do
    before(:each) do
      @note = Factory(:note)
      @label = Factory(:label)
    end
    
    it "has a label" do
      @note.label = @label
      @note.save
      @note.reload.label.should == @label
    end
  end
end