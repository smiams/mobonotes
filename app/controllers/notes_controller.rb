class NotesController < ApplicationController
  def index
    @notes = Note.where(:user => @current_user).created_between(@start_time, @end_time).eager_load(:task).order(:created_at)

    render :action => :index
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

  def update
    @note = Note.find(params[:id])

    @note.content = params[:note][:content]

    respond_to do |format|
      if @note.save
        format.js { render :partial => "notes/table_row", :locals => {:note => @note} }
      else
        format.js { render :text => "Error updating note!", :status => 500 }
      end
    end
  end
end