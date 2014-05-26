require 'spec_helper'

describe LabelsController do
  describe "actions" do
    before(:each) do
      @user = Factory(:user)
      @controller.should_receive(:get_current_user).and_return(@user)
      @controller.instance_variable_set(:@current_user, @user)
    end
  
    describe "GET index" do
      it "should get the index page for the current user's labels" do
        get :index
        response.should render_template("index")
      end
    
      it "should get all of the current user's labels" do
        @user.labels << Label.new(:name => "First Label")
        @user.labels << Label.new(:name => "Second Label")
      
        get :index
      
        label_names = assigns(:labels).map(&:name)
        label_names.length.should == 2
        label_names.should include("First Label")
        label_names.should include("Second Label")
      end
    end
  
    describe "GET edit" do
      before(:each) do
        @label = Factory(:label)
      end
      
      it "should get the edit page for a specific label" do
        get :edit, :user_id => @label.user.id, :id => @label.id
        response.should render_template("edit")
      end
    end
  
    describe "PUT update" do
      before(:each) do
        @label = Factory(:label)
      end

      it "should update a specified label for a specified user" do
        put :update, :user_id => @label.user.id, :label => {:name => "Updated Label"}, :id => @label.id
        
        Label.find(@label.id).name.should == "Updated Label"
        response.should redirect_to user_labels_path(@label.user)
      end
      
      it "should render the label edit page if the label could not be updated" do
        put :update, :user_id => @label.user.id, :label => {:name => ""}, :id => @label.id
        
        response.should render_template("edit")
      end
    end
    
    describe "GET new" do
      it "should get the label creation template" do
        get :new, :user_id => @user.id
        
        assigns(:label).should_not be_nil
        response.should render_template("new")
      end
    end
    
    describe "POST create" do
      it "should create a new label for the specified user" do
        expect {
          post :create, :user_id => @user.id, :label => {:name => "This is a new label."}
        }.to change {Label.count}.from(0).to(1)
        
        assigns(:label).name.should == "This is a new label."
        assigns(:label).user_id.should == @user.id
        response.should redirect_to user_labels_path(@user)
      end
    end
  end
  
  describe "#get_user" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should get the user specified by the user_id parameter" do
      @controller.stub!(:params).and_return({:user_id => @user.id})
      @controller.send(:get_user).should == @user
    end
    
    it "should return the current user if the user_id parametre is nil" do
      @controller.instance_variable_set(:@current_user, @user)
      @controller.stub!(:params).and_return({:user_id => ""})
      @controller.send(:get_user).should == @user
    end
  end
end