require "#{Rails.root.to_s}/lib/modules/note_sorting"

class Users::LabelsController < ApplicationController
  include NoteSorting
  
  before_filter :_get_user
  
  def index
    @labels = @user.labels
    render :action => "index"
  end
  
  def edit
    @label = @user.labels.find(params[:id])
    render :action => "edit"
  end
  
  def update
    @label = @user.labels.find(params[:id])
    
    if @label.update_attributes(params[:label])
      redirect_to user_labels_path(@user)
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
    @label.user_id = @user.id
    
    if @label.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
    
  def notes
    @label = @user.labels.find(params[:id], :include => :notes)
    @notes = @label.notes
    
    set_current_tab(notes_label_path(@label))
    _sort_notes_for_display(@notes)
    
    render :template => "notes/index"  
  end
  
  private
  
  def _get_user
    @user = params[:user_id].present? ? User.find(params[:user_id]) : @current_user
  end
end