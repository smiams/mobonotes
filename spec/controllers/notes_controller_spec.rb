require 'spec_helper'

describe NotesController do
  describe "GET show" do
    it "renders the new template" do
      note = Factory(:note)
      get :show, :id => note.id
      
      response.should render_template("show")
      assigns(:note).should == note
    end  
  end
  
  describe "GET new" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
  end
  
  describe "POST create" do
    it "creates a new note" do
      expect {
        post :create, :note => {:content => "This is a new note."}
      }.to change {Note.count}.from(0).to(1)
      
      response.should render_template("index")
      assigns(:notes).length.should == 1
    end
    
    it "returns an error if it could not create the note" do
      expect {
        post :create, :gibberish => "This is just some gibberish."
      }.to_not change{Note.count}
      
      response.should render_template("new")
    end
  end
  
  describe "actions for existing notes" do
    before(:each) do
      @creation_date = Time.parse("2011-08-20 00:00:00 UTC")
      @note = Factory(:note, :created_at => @creation_date)
    end
    
    describe "GET index" do
      it "renders the index template" do
        get :index
      
        assigns(:notes).length.should == 1
        response.should render_template("index")
      end
      
      it "has a list of note creation dates" do
        another_note = Factory(:note, :content => "This is another note.", :created_at => @creation_date + 1.day)
        
        get :index
        
        assigns(:note_creation_dates).length.should == 2
      end
    end
  
    describe "GET edit" do
      it "renders the edit page for a note" do
        get :edit, :id => @note.id
        
        assigns(:note).id.should == @note.id
        response.should render_template("edit")
      end
    end
    
    describe "PUT update" do
      it "updates a note" do
        put :update, :note => {:content => "This is the updated content."}, :id => @note.id
        
        assigns(:note).content.should == "This is the updated content."
        response.should render_template("show")
      end
      
      it "returns an error if it could not update the note" do
        Note.should_receive(:find).with(@note.id).and_return(@note)
        @note.should_receive(:update_attributes).and_return(false)
        
        put :update, :note => {:content => ""}, :id => @note.id
        
        assigns(:note).id.should == @note.id
        response.should render_template("edit")
      end
    end
  end
  
  describe "#_add_note_to_creation_date" do
    before(:each) do
      @created_at = Time.parse("2011-08-20 00:00:00 UTC")
      @note = Factory(:note, :created_at => @created_at)
    end
    
    context "when the date does not have any notes associated with it" do
      it "adds a note to the date upon which it was created" do
        @controller.send(:_add_note_to_creation_date, @note)
        
        note_creation_dates = @controller.instance_variable_get(:@note_creation_dates)
        note_creation_dates[@created_at.to_date].should == [@note]
      end
    end
    
    context "when the date has notes associated with it" do
      it "adds the additional note to the same date" do
        created_at_date = @created_at.to_date
        @controller.instance_variable_set(:@note_creation_dates, {created_at_date => [@note]})
      
        another_note = Factory(:note, :created_at => @created_at, :content => "This is another note.")
      
        @controller.send(:_add_note_to_creation_date, another_note)
      
        note_creation_dates = @controller.instance_variable_get(:@note_creation_dates)
        note_creation_dates[created_at_date].should == [@note, another_note]
      end
    end
  end
  
  describe "_sort_notes_for_display" do
    it "adds all notes to the @note_creation_dates (hash) instance variable and sorts by the hash key" do
      pending
    end
  end
end