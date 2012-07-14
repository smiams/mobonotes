class DatesController < ApplicationController
  before_filter :get_date

  def show
    @notes = @current_user.notes.created_between(@date.beginning_of_day.utc, @date.end_of_day.utc)

    @tasks = @current_user.tasks.occurs_between(@date.beginning_of_day.utc, @date.end_of_day.utc)
    @tasks += @current_user.tasks.occurs_before(@date.end_of_day.utc).rolling.incomplete
    @tasks += @current_user.tasks.completed_between(@date.beginning_of_day.utc, @date.end_of_day.utc)

    @tasks.uniq!
  end
end