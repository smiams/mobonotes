class TasksController < ApplicationController
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.js { render :action => "replace-task", :locals => {:task => @task}}
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
      format.js { render :action => "replace-edit-form", :locals => {:task => @task, :labels => @labels} }
    end
  end

  def update
    @task = Task.find(params[:id])

    @task.label_id = params[:task][:label_id] if params[:task].present?
    @task.update_attributes(params[:task])

    respond_to do |format|
      format.js { render :partial => "tasks/list_item", :locals => {:task => task, :index => 0}}
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy

    redirect_to :back
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
        format.js { render :action => "replace-task", :locals => {:task => @task} }
      end
    end
  end

  def start
    @task = Task.find(params[:id])

    if @task.start!
      respond_to do |format|
        format.js { render :action => "replace-task", :locals => {:task => @task} }
      end
    end
  end

  def unstart
    @task = Task.find(params[:id])

    if @task.unstart!
      respond_to do |format|
        format.js { render :action => "replace-task", :locals => {:task => @task} }
      end
    end
  end

  def irrelevant
    @task = Task.find(params[:id])

    if @task.irrelevant!
      respond_to do |format|
        format.js { render :action => "remove-task", :locals => {:task => @task} }
      end
    end
  end

  def relevant
    @task = Task.find(params[:id])

    if @task.relevant!
      respond_to do |format|
        format.js { render :action => "remove-task", :locals => {:task => @task} }
      end
    end
  end
end