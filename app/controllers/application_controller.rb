class ApplicationController < ActionController::Base
  protect_from_forgery

  include Rails.application.routes.url_helpers

  before_filter :get_current_user
  before_filter :get_labels
  before_filter :get_current_controller_and_action
  before_filter :_get_current_tab
  before_filter :_set_time_zone
  before_filter :_get_current_time_and_date

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

  def set_current_tab(tab_name)
    session[:current_tab] = tab_name
    _get_current_tab
  end

  private

  def _get_current_time_and_date
    @time = Time.zone.now
    @date = @time.to_date
  end

  def _get_current_tab
    @current_tab = session[:current_tab] || notes_path
  end

  def _set_time_zone
    Time.zone = "Central Time (US & Canada)"
  end
end
