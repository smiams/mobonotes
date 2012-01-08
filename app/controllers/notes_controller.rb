require "#{Rails.root.to_s}/lib/modules/object_sorting"
require "#{Rails.root.to_s}/lib/modules/utilities"

class NotesController < ApplicationController
  def show
    @note = Note.find(params[:id])

    render :action => "show"
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(params[:note])
    @note.user_id = @current_user.id
    @note.label_id = params[:note][:label_id] if params[:note].present?

    if @note.save
      redirect_to :back
    else
      render :action => "new"
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    @note.label_id = params[:note][:label_id] if params[:note].present?
    label_changed = @note.changed.include?("label_id")
    
    if @note.update_attributes(params[:note])
      if @current_tab != notes_path && label_changed && @note.label.present?
        redirect_to notes_label_path(@note.label)
      else
        redirect_to @current_tab
      end
    else
      render :action => "edit"
    end
  end
  
  def index
    @notes = Note.all
    @tasks = Task.all

    set_current_tab(notes_path)

    @note_creation_dates = ObjectSorting.sort_notes_for_display(@notes)
    @task_creation_dates = ObjectSorting.sort_tasks_for_display(@tasks)

    @object_creation_dates = (Utilities.get_keys_from_2d_array(@note_creation_dates) +
                              Utilities.get_keys_from_2d_array(@task_creation_dates))
    @object_creation_dates.uniq!.sort! { |less, greater| greater <=> less }

    render :action => "index"
  end

  def destroy
    @note = Note.find(params[:id])

    @note.destroy
    redirect_to :action => "index"
  end
end