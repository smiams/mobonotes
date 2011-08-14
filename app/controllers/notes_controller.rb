class NotesController < ApplicationController
  def new
    @note = Note.new
  end
  
  def create
    @note = Note.new(params[:note])
    @note.save
    
    head :created, :location => @note.id
  end
end
