class DatesController < ApplicationController
  helper DateRangeNavigatorHelper
  before_filter :_get_time_range

  def show
    @labels = Label.with_current_tasks_for_user(@current_user, @start_time, @end_time)

    respond_to do |format|
      format.html { render "dates/show" }
    end
  end

  private

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