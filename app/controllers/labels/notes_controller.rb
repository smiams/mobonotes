class Labels::NotesController < ApplicationController
  def index
    @label = Label.find(params[:label_id])
    @label_with_tasks = Label.where(:id => @label.id).with_current_tasks_for_user(@current_user, @start_time, @end_time).first

    render :template => "labels/show"
  end
end