require 'spec_helper'

describe NotesController do
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
      @note = Note.create(:content => "This is a new note.")
    end
    
    describe "GET index" do
      it "renders the index template" do
        get :index
      
        assigns(:notes).length.should == 1
        response.should render_template("index")
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
end