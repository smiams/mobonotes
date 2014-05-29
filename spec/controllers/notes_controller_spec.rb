require 'spec_helper'

describe NotesController, :type => :controller do
  before(:all) do
    @current_user = create(:user)
  end
  
  after(:all) do
    @current_user.destroy
  end
  
  before(:each) do
    @controller.instance_variable_set(:@current_user, @current_user)
    @controller.stub(:get_current_user).and_return(true)  
  end
  
  describe "POST create" do
    before(:each) do
      request.env["HTTP_REFERER"] = "http://test.mobonotes/test"
    end
    
    it "creates a new note" do      
      expect {
        post :create, :note => {:content => "This is a new note."}
      }.to change {Note.count}.by(+1)
      
      response.should redirect_to request.referrer
    end
    
    it "returns an error if it could not create the note" do
      expect {
        post :create, :gibberish => "This is just some gibberish."
      }.to_not change{Note.count}
      
      response.should render_template("new")
    end
    
    it "creates a new note with a label" do
      @label = create(:label)
      
      expect {
        post :create, :note => {:content => "This is a new note with a label.", :label_id => @label.id}
      }.to change {Note.count}.by(+1)
      
      assigns(:note).label.should == @label
      response.should redirect_to request.referrer
    end
    
    it "does not create a new note for another user" do
      pending
    end
  end
end