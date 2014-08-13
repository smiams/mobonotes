class DatesController < ApplicationController
  def show
    @labels_with_tasks = Label.with_current_tasks_for_user(@current_user, @start_time, @end_time)

    respond_to do |format|
      format.html { render "dates/show" }
    end
  end
end