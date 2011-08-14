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
      post :create, :content => "This is a new note."
      response.code.should == "201"
    end
  end
end