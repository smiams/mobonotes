class TasksController < ApplicationController
  def create
    @task = Task.new(params[:task])
    @task.user_id = @current_user.id
    @task.label_id = params[:task][:label_id] if params[:task].present?
    
    if @task.save
      redirect_to :back
    else
      render :action => "new"
    end
  end
  
  def complete
    @task = Task.find(params[:id])
    
    if @task.mark_complete
      respond_to do |format|
        format.js { render :action => "toggle_task_completion" }
      end
    end
  end
  
  def uncomplete
    @task = Task.find(params[:id])
    
    if @task.mark_incomplete
      respond_to do |format|
        format.js { render :action => "toggle_task_completion" }
      end
    end
  end
end