require 'spec_helper'

describe Note do
  context "new notes" do
    before :each do
      @note = Note.new
    end
    
    context "without content" do
      it "should be invalid" do
        @note.valid?.should == false
        @note.errors.on(:content).should == "can't be blank"
      end
    end
    
    context "with content" do
      before :each do
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
end