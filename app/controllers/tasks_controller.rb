class TasksController < ApplicationController
  def create
    @task = Task.new(params[:task])
    @task.user_id = @current_user.id
    @task.label_id = params[:task][:label_id] if params[:task].present?

    respond_to do |format|
      if @task.save
        format.js { render :partial => "tasks/list_item", :locals => {:task => @task, :index => 0} }
      else
        format.js { render :text => "Error creating task!", :status => 500 }
      end
    end
  end

  def complete
    @task = Task.find(params[:id])

    if @task.complete!
      respond_to do |format|
        format.js { render :partial => "tasks/list_item", :locals => {:task => @task, :index => 0, :selected => params[:selected]} }
      end
    end
  end

  def uncomplete
    @task = Task.find(params[:id])

    if @task.uncomplete!
      respond_to do |format|
        format.js { render :partial => "tasks/list_item", :locals => {:task => @task, :index => 0, :selected => params[:selected]} }
      end
    end
  end
end