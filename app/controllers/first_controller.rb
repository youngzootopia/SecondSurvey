class FirstController < ApplicationController
  # for InvalidAuthenticityToken
  skip_before_filter :verify_authenticity_token
  
  # 설문 페이지
  def get_page
    @user = User.find(session[:user_id])
    unless Filtering.exists? @user.sUserID
      redirect_to "/filtering" 
    end
    
    @first_survey = FirstSurvey.new
  end
  
  # 정보 요청할 떄
  def get_json
    get_infomation
    
    request.format = :json
    respond_to do |format|
    format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURL: @videoURL, CID: @CID, title: @title] }
    end
  end
  
  # 설문 결과 저장하고 정보 전송
  def survey_commit
    # 아이디 가져오고
    @user = User.find(session[:user_id])
    
    # form 데이터 받아오고 아이디 추가
    @first = FirstSurvey.new
    @data = JSON.parse(params[:survey])
    @first.cID = @data["cID"]
    @first.shotID = @data["shotID"]
    @first.fileName = @data["fileName"]
    @first.preference = @data["preference"]
    @first.reason = @data["reason"]
    @first.timestamp = Time.now
    @first.sUserID = @user.sUserID
       
    if @first.save # 데이터베이스에 잘 저장 되었다면
      # currentShot 증가
      @user.currentShot += @user.group
      if @user.save # 데이터베이스에 잘 저장 되었다면
        # 정보 전송
        get_infomation
              
        request.format = :json
        respond_to do |format|
        format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURL: @videoURL, CID: @CID, title: @title] }
        end
      else # user 저장 실패
        render 'get_json'
      end
      
    else # first_survey 저장 실패
      render 'get_json'
    end
    
    
  end
  
  private
    # currentShot으로 샷을 셀렉트함. 특정 샷이 없을 경우 nil 반환
    def get_shot
      begin
        shot = ShotInfo.find(@user.currentShot)
        return shot
      rescue ActiveRecord::RecordNotFound => e
        return nil
      end
    end
    
    # 샷 리스트, 시작시간, 끝 시간, 동영상 URL, CID, 동영상 제목 등 정보를 가져와 변수에 할당하는 함수
    def get_infomation
      @user = User.find(session[:user_id])
      
      # currentShot 증가. 첫 접속이라면 1부터 시작
      if @user.currentShot == 0
        @user.currentShot = 1
      end
      
      # 마지막 샷이라면
      @lastShot = ShotInfo.last
      # render '마지막 함수' if @user.currentShot == 마지막 샷 번호
      
      # currentShot 가져오기
      @shot = get_shot
      while @shot == nil
        @user.currentShot += 1
        @shot = get_shot
      end
      
      # video 가져오기
      @video = Clist.find(@shot.CID)
      
      # shot List 가져오기
      @shotList = ShotInfo.where("CID = #{@video.CID} AND ShotID >= #{@user.currentShot}")
      
      # 그룹별로 해당 샷이 다르기 때문에 설문 대상 샷 번호, 시작시간, 끝시간 리스트를 만들어 줌
      @shotIDList = Array.new
      @startTimeList = Array.new
      @endTimeList = Array.new
      @user.currentShot.step(@shotList.last.ShotID, @user.group) do |shotID|
        @shotIDList.push shotID
        @startTimeList.push(@shotList.find(shotID).StartFrame / @video.FPS)
        @endTimeList.push(@shotList.find(shotID).EndFrame / @video.FPS) 
      end
      
      # 동영상 스테틱 URL 미완.
      @videoURL = @video.VideoFileName
      
      # CID, 동영상 제목
      @CID = @video.CID
      @title = @video.ProgramNameKor
    end
end
