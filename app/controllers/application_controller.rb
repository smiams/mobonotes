class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :get_current_user
  before_filter :get_labels
  before_filter :get_current_controller_and_action
  before_filter :_set_time_zone
  
  def get_current_user
    @current_user = session[:user_id] && User.exists?(session[:user_id]) ? User.find(session[:user_id], :include => :labels) : nil
    redirect_to login_path if @current_user.nil?
  end

  def get_labels
    @labels = @current_user.labels
  end
  
  def get_current_controller_and_action
    symbolized_path_parameters = request.symbolized_path_parameters
    @current_controller = symbolized_path_parameters[:controller]
    @current_action = symbolized_path_parameters[:action]
    @current_id = symbolized_path_parameters[:id]
  end
  
  private
  
  def _set_time_zone
    Time.zone = "Central Time (US & Canada)"
  end
end
