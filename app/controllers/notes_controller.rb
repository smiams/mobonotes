class NotesController < ApplicationController
  def create
    label_id = params[:note].try(:delete, :label_id)
    @note = Note.new(params[:note])
    @note.user_id = @current_user.id
    @note.label_id = label_id

    if @note.save
      redirect_to :back
    else
      render :action => "new"
    end
  end
end