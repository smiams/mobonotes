class Labels::DatesController < ApplicationController
  before_filter :_get_label, :get_date

  def show
    @notes = @label.notes.created_between(@date.beginning_of_day.utc, @date.end_of_day.utc)

    @tasks = @label.tasks.occurs_between(@date.beginning_of_day.utc, @date.end_of_day.utc)
    @tasks += @label.tasks.occurs_before(@date.end_of_day.utc).rolling.incomplete
    @tasks.uniq!

    respond_to do |format|
      format.html { render "dates/show" }
    end
  end

  # The #index action should show a calendar or something...
  # def index
  # 
  # end

  private

  def _get_label
    @label = @current_user.labels.find(params[:label_id])
  end
end