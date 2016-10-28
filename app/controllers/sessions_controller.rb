class SessionsController < ApplicationController
  def new
  end
 
  def create
    user = User.find_by(sUserID: params[:session][:sUserID])
    
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash[:danger] = 'Invalid id/password combination' # Not quite right!
      render 'new'
    end
  end
 
  def destroy
    log_out
    redirect_to root_url
  end
end
