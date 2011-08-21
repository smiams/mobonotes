class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :_set_time_zone
  
  private
  
  def _set_time_zone
    Time.zone = "Central Time (US & Canada)"
  end
end
