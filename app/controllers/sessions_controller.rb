class SessionsController < ApplicationController
  skip_before_filter :get_current_user, :except => [:destroy]
  skip_before_filter :get_labels
  
  layout false
  
  def new
    render :action => "new"
  end

  def create
    @user = User.find_by_email_address(params[:session][:email_address])
    
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to login_path
    end
  end
    
  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end