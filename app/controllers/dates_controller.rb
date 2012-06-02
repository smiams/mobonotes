class DatesController < ApplicationController
  before_filter :get_date

  def show
    @notes = @current_user.notes.created_between(@date.beginning_of_day.utc, @date.end_of_day.utc)
    @tasks = @current_user.tasks.created_between(@date.beginning_of_day.utc, @date.end_of_day.utc)
  end
end