require 'spec_helper'

describe NotesController do
  before(:all) do
    @current_user = Factory(:user)
  end
  
  after(:all) do
    @current_user.destroy
  end
  
  before(:each) do
    @controller.instance_variable_set(:@current_user, @current_user)
    @controller.stub!(:get_current_user).and_return(true)  
  end
  
  describe "GET show" do    
    it "renders the show template" do
      note = Factory(:note, :user => Factory(:user))
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
    before(:each) do
      request.env["HTTP_REFERER"] = Rails.application.routes.generate :controller => "notes", :action => "index"
    end
    
    it "creates a new note" do      
      expect {
        post :create, :note => {:content => "This is a new note."}
      }.to change {Note.count}.from(0).to(1)
      
      response.should redirect_to request.env["HTTP_REFERER"]
    end
    
    it "returns an error if it could not create the note" do
      expect {
        post :create, :gibberish => "This is just some gibberish."
      }.to_not change{Note.count}
      
      response.should render_template("new")
    end
    
    it "creates a new note with a label" do
      @label = Factory(:label)
      
      expect {
        post :create, :note => {:content => "This is a new note with a label.", :label_id => @label.id}
      }.to change {Note.count}.from(0).to(1)
      
      assigns(:note).label.should == @label
      response.should redirect_to notes_path
    end
    
    it "does not create a new note for another user" do
      pending
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      @note = Factory(:note, :user => Factory(:user))
    end
    
    it "deletes a note" do
      expect {
        delete :destroy, :id => @note.id
      }.to change {Note.count}.from(1).to(0)
    end
    
    it "does not delete the note if it does not belong to the current user" do
      pending
    end
  end
  
  describe "actions for existing notes" do
    before(:each) do
      @note = Factory(:note, :created_at => STANDARD_FROZEN_TIME, :user => Factory(:user))
    end
    
    describe "GET index" do
      it "renders the index template" do
        get :index
      
        assigns(:notes).length.should == 1
        response.should render_template("index")
      end
      
      it "has a list of note creation dates" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          another_note = Factory(:note, :content => "This is another note.", :user => Factory(:user), :created_at => Time.now + 1.day)
          get :index
      
          assigns(:note_creation_dates).length.should == 2
        end
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
        response.should redirect_to notes_path
      end
      
      it "returns an error if it could not update the note" do
        Note.should_receive(:find).with(@note.id).and_return(@note)
        @note.should_receive(:update_attributes).and_return(false)
        
        put :update, :note => {:content => ""}, :id => @note.id
        
        assigns(:note).id.should == @note.id
        response.should render_template("edit")
      end

      it "updates the label_id on a note" do
        @label = Factory(:label)
        put :update, :note => {:content => "This is the updated content.", :label_id => @label.id}, :id => @note.id

        assigns(:note).label.should == @label
        response.should redirect_to notes_path
      end

      it "redirects back to the current_tab" do
        put :update, :note => {:content => "This is the updated content."}, :id => @note.id

        response.should redirect_to controller.instance_variable_get(:@current_tab)
      end

      it "redirects to the note's new notes_label_path if the current tab is not notes_path, and the label has been changed" do
        @label = Factory(:label)
        session[:current_tab] = notes_label_path(Label.all.first)
        put :update, :note => {:content => "This is the updated content.", :label_id => @label.id}, :id => @note.id

        response.should redirect_to notes_label_path(@label)
      end

      it "redirects to notes_path if the current tab is notes_path, and the label has been changed" do
        @label = Factory(:label)
        session[:current_tab] = notes_path
        put :update, :note => {:content => "This is the updated content.", :label_id => @label.id}, :id => @note.id

        response.should redirect_to notes_path
      end
      
      it "does not update a note that does not belong to the current user" do
        pending
      end
    end
  end

  describe "#_add_note_to_creation_date" do
    before(:each) do
      @note = Factory(:note, :created_at => STANDARD_FROZEN_TIME, :user => Factory(:user))
    end

    context "when the date does not have any notes associated with it" do
      it "adds a note to the date upon which it was created" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do
          @controller.send(:_add_note_to_creation_date, @note)
        
          note_creation_dates = @controller.instance_variable_get(:@note_creation_dates)
          note_creation_dates[Time.now.to_date].should == [@note]
        end
      end
    end
    
    context "when the date has notes associated with it" do
      it "adds the additional note to the same date" do
        Timecop.freeze(STANDARD_FROZEN_TIME) do                
          @controller.instance_variable_set(:@note_creation_dates, {Time.now.to_date => [@note]})
      
          another_note = Factory(:note, :created_at => Time.now, :content => "This is another note.", :user => Factory(:user))
      
          @controller.send(:_add_note_to_creation_date, another_note)
      
          note_creation_dates = @controller.instance_variable_get(:@note_creation_dates)
          note_creation_dates[Time.now.to_date].should == [@note, another_note]
        end
      end
    end
  end
  
  describe "_sort_notes_for_display" do
    it "adds all notes to the @note_creation_dates (hash) instance variable and sorts by the hash key" do
      pending
    end
  end
end