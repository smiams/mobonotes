require "#{Rails.root.to_s}/lib/modules/note_sorting"

class NotesController < ApplicationController
  include NoteSorting
  
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
    
    if @note.update_attributes(params[:note])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def index
    @notes = Note.all
    _sort_notes_for_display(@notes)

    render :action => "index"
  end
  
  def destroy
    @note = Note.find(params[:id])
    
    @note.destroy
    redirect_to :action => "index"
  end
end