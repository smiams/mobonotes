class ApplicationController < ActionController::Base
  protect_from_forgery

  include Rails.application.routes.url_helpers

  helper NavigatorHelper

  before_filter :set_time_zone
  before_filter :_get_current_user
  before_filter :_get_labels
  before_filter :_get_current_controller_and_action
  before_filter :_get_current_tab
  before_filter :_get_date_time
  before_filter :_get_time_range
  before_filter :_get_current_tab

  def set_time_zone(time_zone = "Central Time (US & Canada)")
    Time.zone = time_zone
  end

  private

  def _get_current_user
    @current_user = session[:user_id] && User.exists?(session[:user_id]) ? User.includes(:labels).find(session[:user_id]) : nil
    redirect_to login_path if @current_user.nil?
  end

  def _get_labels
    @labels = @current_user.labels
  end

  def _get_current_controller_and_action
    symbolized_path_parameters = request.symbolized_path_parameters
    @current_controller = symbolized_path_parameters[:controller]
    @current_action = symbolized_path_parameters[:action]
    @current_id = symbolized_path_parameters[:id]
  end

  def _get_current_tab
    @current_tab = Mobonotes::Application.config.tab_mappings[@current_controller] || "tasks"
  end

  def _get_date_time
    @date_time = Time.zone.now
  end

  def _get_time_range
    if params[:start_date]
      @start_time = Time.zone.parse(params[:start_date]).beginning_of_day
    end

    if params[:end_date]
      @end_time = Time.zone.parse(params[:end_date]).end_of_day
    elsif @start_time
      @end_time = @start_time.end_of_day
    else
      @end_time = @date_time.end_of_day
    end

    unless @start_time
      @start_time = @date_time.beginning_of_day
      @end_time = @date_time.end_of_day
    end
  end
end