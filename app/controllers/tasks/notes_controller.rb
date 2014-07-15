class Tasks::NotesController < ApplicationController
  before_filter :_get_task

  def create
    @note = Note.new
    @note.user = @current_user
    @note.task = @task
    @note.content = params[:note][:content]

    respond_to do |format|
      if @note.save
        format.js { render :partial => "tasks/notes/list_item", :locals => {:note => @note, :index => 0} }
      end
    end
  end

  def update
    @note = @task.notes.find(params[:id])
    @note.content = params[:note][:content]

    respond_to do |format|
      if @note.save
        format.js { render :partial => "tasks/notes/list_item", :locals => {:note => @note, :index => 0} }
      end
    end
  end

  def destroy
    @note = @task.notes.find(params[:id])

    respond_to do |format|
      if @note.destroy!
        format.js { head :ok }
      else
        format.js { head :error }
      end
    end
  end

  private

  def _get_task
    @task = @current_user.tasks.find(params[:task_id])
  end
end