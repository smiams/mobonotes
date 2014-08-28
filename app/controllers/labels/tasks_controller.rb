class Labels::TasksController < ApplicationController
  def index
    @label = Label.find(params[:label_id])
    @label_with_tasks = Label.where(:id => @label.id).with_current_tasks_for_user(@current_user, @start_time, @end_time).first

    render :action => :index
  end
end