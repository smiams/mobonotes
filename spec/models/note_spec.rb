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
      
      context "and without a user" do
        it "should be invalid" do
          @note.valid?.should == false
          @note.errors[:user].first.should == "can't be blank"
        end
      end

      context "and with a user" do
        before(:each) do
          @user = build(:user)
          @note.user = @user
        end
        
        it "should be valid" do
          @note.valid?.should == true
        end
        
        it "should be created" do
          expect {
            @note.save.should == true
          }.to change {Note.count}.by(+1)
        end
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
      expect {
        @note.update_attributes(:created_at => Time.now)
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)

      @note.created_at.should == nil
    end
  end

  context "created between" do
    it "should return the correct notes" do
      Timecop.freeze(STANDARD_FROZEN_TIME) do
        user = create(:user)
        note_1 = create(:note, :created_at => Time.now - 1.day, :user => user)
        note_2 = create(:note, :created_at => Time.now - 1.second, :user => user)
        note_3 = create(:note, :created_at => Time.now + 0.seconds, :user => user)
        note_4 = create(:note, :created_at => Time.now + 1.second, :user => user)
        
        notes = Note.created_between(Time.now - 1.day, Time.now)

        notes.should == [note_1, note_2, note_3]
      end
    end
  end
  
  context "with a label" do
    before(:each) do
      @note = build(:note)
      @note.user = build(:user)
      @note.save
      @label = build(:label)
    end
    
    it "has a label" do
      @note.label = @label
      @note.save
      @note.reload.label.should == @label
    end
  end   
end