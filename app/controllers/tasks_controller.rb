class TasksController < ApplicationController
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.js { render :action => "show_task"}
    end  
  end

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

  def edit
    @task = Task.find(params[:id])

    respond_to do |format|
      format.js { render :action => "show_edit_form"}
    end
  end

  def update
    @task = Task.find(params[:id])

    @task.label_id = params[:task][:label_id] if params[:task].present?
    @task.update_attributes(params[:task])

    respond_to do |format|
      format.js { render :action => "show_task" }
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy

    redirect_to :back
  end

  def complete
    @task = Task.find(params[:id])

    if @task.mark_complete
      respond_to do |format|
        format.js { render :action => "show_task" }
      end
    end
  end

  def uncomplete
    @task = Task.find(params[:id])

    if @task.mark_incomplete
      respond_to do |format|
        format.js { render :action => "show_task" }
      end
    end
  end
end