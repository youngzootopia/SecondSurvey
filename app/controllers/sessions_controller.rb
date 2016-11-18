class SessionsController < ApplicationController
  def new
    # 로그인 했으면 1차 설문으로 보냄
    if logged_in?
      @user = User.find(session[:user_id]) 
      unless Filtering.exists? @user.sUserID
        @filtering = Filtering.new
        render :controller_name => :filterings, :action_name => :new, :template => "filterings/new"
        
      else
        # 진행상황 나오면 수정 필요 
        render :controller_name => :first, :action_name => :get_page, :template => "first/get_page"
      end
    end
  end
 
  def create
    user = User.find_by(sUserID: params[:session][:sUserID])
    
    if user && user.authenticate(params[:session][:password])
      log_in user
      # 진행상황 나오면 수정 필요 
      redirect_to "/first"
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
