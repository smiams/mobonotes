class DatesController < ApplicationController
  def show
    if params[:year].present? && params[:month].present? && params[:day].present?
      @date = Time.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}").to_date
    else
      @date = Time.zone.now.to_date
    end

    @notes = @current_user.notes.where("created_at BETWEEN ? AND ?", @date.beginning_of_day.utc, @date.end_of_day.utc)
    @tasks = Task.where("created_at BETWEEN ? AND ?", @date.beginning_of_day.utc, @date.end_of_day.utc)
    @labels = @current_user.labels
  end
end