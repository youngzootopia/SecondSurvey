class UsersController < ApplicationController
  def show
      @user = User.find(params[:id])
    end
  
  def new
      @user = User.new
  end
    
  def create
    @user = User.new(user_params)    # Not the final implementation!
    
    # 처음 가입하는 유저는 currentShot이 0으로 초기화
    @user.currentShot = 0
    
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      render 'show'
    else
      render 'new'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:sUserID, :name, :password, :password_confirmation, :birthday, :sex, :married, :children, :job, :hobby)
    end
end
