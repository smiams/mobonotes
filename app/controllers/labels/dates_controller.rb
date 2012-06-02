class Labels::DatesController < ApplicationController
  before_filter :_get_label, :get_date

  def show
    @notes = @label.notes.where("created_at BETWEEN ? AND ?", @date.beginning_of_day.utc, @date.end_of_day.utc)
    @tasks = @label.tasks.where("created_at BETWEEN ? AND ?", @date.beginning_of_day.utc, @date.end_of_day.utc)

    respond_to do |format|
      format.html { render "dates/show" }
    end
  end

  private

  def _get_label
    @label = @current_user.labels.find(params[:label_id])
  end
end