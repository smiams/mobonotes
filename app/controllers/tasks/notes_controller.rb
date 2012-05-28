class Tasks::NotesController < ApplicationController
  before_filter :_get_task

  def create
    @note = Note.new
    @note.user = @current_user
    @note.task = @task
    @note.content = params[:note][:content]

    respond_to do |format|
      if @note.save
        format.js { render :action => "add", :locals => {:task => @task, :note => @note} }
      end
    end
  end

  private

  def _get_task
    @task = @current_user.tasks.find(params[:task_id])
  end
end