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

    if @note.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
  def edit
    @note = Note.find(params[:id])
  end
  
  def update
    @note = Note.find(params[:id])
    
    if @note.update_attributes(params[:note])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end
  
  def index
    @notes = Note.all
    _sort_notes_for_display(@notes)

    # The "render :action => "index"" line must be explicitly stated so the #create method can call it upon creating a new Note.
    render :action => "index"
  end
  
  private
  
  def _sort_notes_for_display(notes)
    notes.each { |note| _add_note_to_creation_date(note) }
    @note_creation_dates = @note_creation_dates.sort { |less, greater| greater <=> less }
  end
  
  def _add_note_to_creation_date(note)
    @note_creation_dates ||= { }
    notes = @note_creation_dates[note.created_at.to_date] || []
    notes << note
    notes.sort! { |less, greater| greater.created_at <=> less.created_at }
    @note_creation_dates[note.created_at.to_date] = notes
  end
end
