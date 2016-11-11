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
  
  # ADMIN
  # user 리스트 보기
  def index
    @users = User.all
  end
  
  # 관리자가 유저를 추가할 떄
  def admin_new
    @user = User.new
  end
  
  def admin_create
    @user = User.new(admin_user_params)
    
    respond_to do |format|
      begin
        @user.save
        format.html { redirect_to "/admin/users", notice: "#{@user.name} 회원이 정상적으로 추가되었습니다." }
      rescue ActiveRecord::InvalidForeignKey  => e
        format.html { redirect_to "/admin/users/admin_new", notice: "회원 추가에 실패했습니다." }
      end
    end
  end
  
  # 관리자가 유저 정보를 수정할 떄
  def admin_edit
    @user = User.find(params[:sUserID])
  end
  
  def admin_update
    @user = User.find(params[:sUserID])
    
    respond_to do |format|
      if @user.update(admin_update_params)
        format.html { redirect_to "/admin/users", notice: "#{@user.name}의 정보가 정상적으로 수정되었습니다." }
      else
        format.html { render :admin_edit }
      end
    end
  end
  
  # 관리자가 유저를 삭제할 때
  def destroy
    @user = User.find(params[:sUserID])
    @name = @user.name
    @user.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/users", notice: "#{@name} 회원이 정상적으로 삭제되었습니다." }
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
    
    # ADMIN
    # 관리자 수정 form 파라미터들
    def admin_update_params
      # 2차 설문 추가 필요
      params.require(:user).permit(:sUserID, :name, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby, :currentShot, :group)
    end
    
    # 관리자 추가 form 파라미터들
    def admin_user_params
      # 2차 설문 추가 필요
      params.require(:user).permit(:sUserID, :name, :password, :password_confirmation, :birthday, :phone, :sex, :married, :children, :job, :company, :hobby, :currentShot, :group)
    end
end
