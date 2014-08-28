class NotesController < ApplicationController
  def index
    # render :acti => "notes/index"
  end

  def create
    @note = Note.new(params[:note])
    @note.user_id = @current_user.id
    @note.label_id = params[:note][:label_id] if params[:note].present?

    respond_to do |format|
      if @note.save
        format.js { render :partial => "notes/list_item", :locals => {:note => @note, :index => 0} }
      else
        format.js { render :text => "Error creating note!", :status => 500 }
      end
    end
  end
end