class DatesController < ApplicationController
  before_filter :get_date

  def show
    @notes = @current_user.notes.created_between(@date.beginning_of_day.utc, @date.end_of_day.utc)

    @tasks = @current_user.tasks.occurs_between(@date.beginning_of_day.utc, @date.end_of_day.utc).relevant
    @tasks += @current_user.tasks.occurs_before(@date.end_of_day.utc).rolling.incomplete.relevant
    @tasks += @current_user.tasks.completed_between(@date.beginning_of_day.utc, @date.end_of_day.utc).relevant

    @tasks.uniq!

    @irrelevant_tasks = @current_user.tasks.irrelevant_between(@date.beginning_of_day.utc, @date.end_of_day.utc)

    respond_to do |format|
      format.html { render "dates/show" }
    end
  end
end