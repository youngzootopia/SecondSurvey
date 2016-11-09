class UsersController < ApplicationController
  # 회원가입시 보여지는 창
  def show
    @user = User.find(params[:id])
  end
  
  # 회원가입 버튼 클릭 시 GET
  def new
    # 로그인 했으면 1차 설문으로 보냄
    if logged_in?
      @user = User.find(session[:user_id]) 
      unless Filtering.exists? @user.sUserID
        @filtering = Filtering.new
        render :controller_name => :filterings, :action_name => :new, :template => "filterings/new"
        
      else
        render :controller_name => :first, :action_name => :get_page, :template => "first/get_page"
      end
      
    else
      @user = User.new
    end
  end
  
  # 회원가입 완료 시 Post
  def create
    @user = User.new(user_params)    # Not the final implementation!
    
    # 처음 가입하는 유저는 currentShot이 0으로 초기화
    @user.currentShot = 0
    
    # group 구분 해야 함. 확실하지 않기 때문에 일단 1로 할당.
    @user.group = 1
    
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      render 'show'
    else
      render 'new'
    end
  end
  
  # 회원정보 변경 시 GET
  def edit
    @user = User.find(session[:user_id])
  end
    
  # 회원정보 변경 시 POST
  def update
    @user = User.find(session[:user_id])

    if @user.update(update_params)
      render 'show'
    else
      render 'edit'
    end
  end
  
  # 비밀번호 변경 시 GET
  def password_edit
    @user = User.new
  end
    
  # 비밀번호 변경 시 POST
  def password_update
    @user = User.find(session[:user_id])

    if @user.update(password_params)
      render 'show'
    else
      render 'password_edit'
    end
  end
  
  private
    # 회원가입 시 form 파라미터들
    def user_params
      params.require(:user).permit(:sUserID, :name, :password, :password_confirmation, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby)
    end 
    
    # 회원정보 변경 시 form 파라미터들
    def update_params
      params.require(:user).permit(:name, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby)
    end
    
    # 비밀번호 변경 시 form 파라미터들
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
