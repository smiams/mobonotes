class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :get_current_user
  before_filter :_set_time_zone
  
  def get_current_user
    @current_user = session[:user_id] && User.exists?(session[:user_id]) ? User.find(session[:user_id]) : nil
    redirect_to login_path if @current_user.nil?
  end

  private
  
  def _set_time_zone
    Time.zone = "Central Time (US & Canada)"
  end
end
