class Users::LabelsController < ApplicationController
  before_filter :get_user
  
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
  
  def show
    @notes = @user.labels.find(params[:id]).notes
    render :template => "notes/index"
  end
  
  private
  
  def get_user
    @user = params[:user_id].present? ? User.find(params[:user_id]) : @current_user
  end
end