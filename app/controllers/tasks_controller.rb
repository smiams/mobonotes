class TasksController < ApplicationController
  def index
    @labels_with_tasks = Label.with_current_tasks_for_user(@current_user, @start_time, @end_time)

    render :template => "dates/show"
  end

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

  def update
    @task = Task.find(params[:id])

    @task.name = params[:task][:name]
    @task.rolling = params[:task][:rolling]

    respond_to do |format|
      if @task.save
        format.js { render :partial => "tasks/list_item", :locals => {:task => @task, :index => 0, :selected => params[:selected]} }
      else
        format.js { render :text => "Error creating task!", :status => 500 }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.destroy!
        format.js { head :ok }
      else
        format.js { head :error }
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