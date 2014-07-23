class DatesController < ApplicationController
  before_filter :get_date

  def show
    @labels = Label.with_current_tasks_for_user(@current_user, @date.beginning_of_day, @date.end_of_day)

    respond_to do |format|
      format.html { render "dates/show" }
    end
  end
end