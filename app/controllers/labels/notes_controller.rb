class Labels::NotesController < ApplicationController
  def index
    @label = Label.find(params[:label_id])
    @notes = @label.notes.created_between(@start_time, @end_time).where(:user => @current_user).eager_load(:task).order(:created_at)

    render :template => "notes/index"
  end
end