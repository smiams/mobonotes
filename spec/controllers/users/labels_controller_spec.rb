require 'spec_helper'

describe Users::LabelsController do
  describe "GET index" do
    it "should get the index page for the current user's labels" do
      @controller.should_receive(:get_current_user).and_return(FactoryGirl.build(:user))
      get :index
      response.should render_template("index")
    end
  end
end