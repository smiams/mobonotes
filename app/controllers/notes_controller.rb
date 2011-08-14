class NotesController < ApplicationController
  def new
    @note = Note.new
  end
  
  def create
    @note = Note.new(params[:note])

    if @note.save
      return index
    else
      render :action => "new"
    end
  end
  
  def index
    @notes = Note.all
    
    # The "render :action => "index"" line must be explicitly stated so the #create method can call it upon creating a new Note.
    render :action => "index"
  end
end
