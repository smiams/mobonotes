class LabelsController < ApplicationController
  def show
    @label = Label.find(params[:id])
    @label_with_tasks = Label.where(:id => params[:id]).with_current_tasks_for_user(@current_user, @start_time, @end_time).first
  end
end