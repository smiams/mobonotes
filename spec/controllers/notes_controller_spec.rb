require 'spec_helper'

describe NotesController do
  describe "GET new" do
    it "renders the new template" do
      get :new
      response.should render_template("new")
    end
  end
  
  describe "POST create" do
    it "creates a new Note" do
      expect {
        post :create, :note => {:content => "This is a new note."}
      }.to change {Note.count}.from(0).to(1)
      
      response.should render_template("index")
      assigns(:notes).length.should == 1
    end
    
    it "returns an error if it could not create the Note" do
      expect {
        post :create, :gibberish => "This is just some gibberish."
      }.to_not change{Note.count}
      
      response.should render_template("new")
    end
  end
  
  describe "GET index" do
    it "renders the index template" do
      Note.create(:content => "This is a new note.")
      get :index
      
      assigns(:notes).length.should == 1
      response.should render_template("index")
    end
  end
end