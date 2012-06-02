require "#{Rails.root.to_s}/lib/modules/object_sorting"
require "#{Rails.root.to_s}/lib/modules/utilities"

class LabelsController < ApplicationController

  def index
    @labels = @current_user.labels
    render :action => "index"
  end

  def edit
    @label = @current_user.labels.find(params[:id])
    render :action => "edit"
  end

  def update
    @label = @current_user.labels.find(params[:id])

    if @label.update_attributes(params[:label])
      redirect_to user_labels_path(@current_user)
    else
      render :action => "edit"
    end
  end

  def new
    @label = Label.new
    render :action => "new"
  end

  def create
    @label = Label.new(params[:label])
    @label.user_id = @current_user.id

    if @label.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def notes
    @label = @current_user.labels.find(params[:id], :include => :notes)
    @notes = @label.notes
    @tasks = @label.tasks

    set_current_tab(notes_label_path(@label))

    @note_creation_dates = ObjectSorting.sort_notes_for_display(@notes)
    @task_creation_dates = ObjectSorting.sort_tasks_for_display(@tasks)

    @object_creation_dates = (Utilities.get_keys_from_2d_array(@note_creation_dates) +
                              Utilities.get_keys_from_2d_array(@task_creation_dates))
    @object_creation_dates.uniq!.sort! { |less, greater| greater <=> less }


    render :template => "notes/index"
  end
end