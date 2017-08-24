require 'net/http'

class SecondController < ApplicationController
  # for InvalidAuthenticityToken
  skip_before_filter :verify_authenticity_token
  
  # 설문 페이지
  def get_page
    if session[:user_id]
      @user = User.find(session[:user_id])
            
      unless Filtering.exists? @user.sUserID
        redirect_to "/filtering" 
      end
    else
      redirect_to "/login"
    end
  end
  
  #-------------------------- 1차 쿼리
  # 1차 쿼리 정보 요청할 떄
  def get_first_json
    first
    
    request.format = :json
    respond_to do |format|
    format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURLList: @videoURLList, totalScoreList: @totalScoreList, thumbList: @thumbList, queryIDList: @queryIDList] }
    end
  end
  
  # 1차 쿼리 저장하고 2차 쿼리로 넘어감
  def first_commit       
    # 유저 정보 받아오고
    if session[:user_id]
      @user = User.find(session[:user_id])
      # form 데이터 받아오고 for문
      @surveyList = JSON.parse(params[:data])
          
      for @survey in @surveyList
        @firstQuerySurvey = FirstQuerySurvey.new
        @firstQuerySurvey.queryID = @survey["queryID"]
        @firstQuerySurvey.shotID = @survey["shotID"]
        @firstQuerySurvey.totalScore = @survey["totalScore"]
        @firstQuerySurvey.correct = @survey["correct"]
        @firstQuerySurvey.preference = @survey["preference"]
        @firstQuerySurvey.reason = @survey["reason"]
        @firstQuerySurvey.isSelect = @survey["isSelect"]
            
        if @firstQuerySurvey.save # 데이터베이스에 잘 저장 되었다면
          next
        else
          render 'get_page'
        end              
      end
    else
      redirect_to "/login"
    end
  end
  
  #-------------------------- 2차 쿼리
  # 2차 쿼리 정보 요청할 떄
  def get_second_json
    second
    
    request.format = :json
    respond_to do |format|
    format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURLList: @videoURLList, totalScoreList: @totalScoreList, thumbList: @thumbList, queryIDList: @queryIDList] }
    end
  end
  
  # 2차 쿼리 저장하고 다시 2차 설문으로 넘어감
  def second_commit
    # 유저 정보 받아오고
    if session[:user_id]
      @user = User.find(session[:user_id])
    
      # form 데이터 받아오고 for문
      @surveyList = JSON.parse(params[:data])
        
      for @survey in @surveyList
        @secondQuerySurvey = SecondQuerySurvey.new
        @secondQuerySurvey.queryID = @survey["queryID"]
        @secondQuerySurvey.shotID = @survey["shotID"]
        @secondQuerySurvey.firstQueryID = @survey["firstQueryID"]
        @secondQuerySurvey.totalScore = @survey["totalScore"]
        @secondQuerySurvey.correct = @survey["correct"]
        @secondQuerySurvey.similarity = @survey["similar"]
        @secondQuerySurvey.preference = @survey["preference"]
        @secondQuerySurvey.reason = @survey["reason"]
        @secondQuerySurvey.isSelect = @survey["isSelect"]
        
        if @secondQuerySurvey.save # 데이터베이스에 잘 저장 되었다면
          next
        else
          render 'get_page'
        end              
      end
      
      @user.querys += 1 # query  1 증가
      if @user.save # 데이터베이스에 잘 저장 되었다면
        @max = MaxQuery.find(1)
        if @user.querys >= @max.max
          redirect_to "/contact"
        end
      else
        render 'get_page'                
      end
    else
      redirect_to "/login"
    end
  end
  
  #------------------------ ADMIN
  #------------------------ 1차 쿼리
  # for first_quries 테이블. 삭제는 가능하나 수정은 불가능함. ETRI에서 주는 데이터가 있기 때문
  # 1차 쿼리 리스트 보기
  def first_index
    @firstQueries = FirstQuery.all
  end
  # 1차 쿼리 삭제
  def first_destroy
    @firstQuery = FirstQuery.find(params[:queryID])
    @sUserID = @firstQuery.sUserID
    @firstQuery.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/first_query", notice: "#{@sUserID}의 queryID = #{params[:queryID]} 1차 쿼리가 정상적으로 삭제되었습니다." }
    end
  end
  # for first_query_tags 테이블. 삭제, 수정 모두 불가능함. 삭제하고 싶다면 1차 쿼리 리스트에서 같은 queryID를 삭제
  # 1차 쿼리 태그 리스트 보기
  def first_tag_index
    @tags = FirstQueryTag.all
  end
  # 1차 쿼리 설문 리스트 보기
  def first_query_survey_index
    @firstQuerySurveys = FirstQuerySurvey.all
  end
  def first_query_survey_edit
    @firstQuerySurvey = FirstQuerySurvey.where("queryID = #{params[:queryID]} AND shotID = #{params[:shotID]}")[0]
  end
  def first_query_survey_update
    @firstQuerySurvey = FirstQuerySurvey.where("queryID = #{params[:first_query_survey][:queryID]} AND shotID = #{params[:first_query_survey][:shotID]}")[0]
    
    respond_to do |format|
      if @firstQuerySurvey.update(first_params)
        format.html { redirect_to "/admin/first_query_survey", notice: "쿼리아이디 = #{@firstQuerySurvey.queryID}, 샷아이디 = #{@firstQuerySurvey.shotID} 설문이 정상적으로 수정되었습니다." }
      else
        format.html { render :first_query_survey_edit }
      end
    end
  end
  
  #------------------------ 2차 쿼리
  # for second_quries 테이블
  # 2차 쿼리 리스트 보기. 삭제는 가능하나 수정은 불가능함. ETRI에서 주는 데이터가 있기 때문
  def second_index
    @secondQueries = SecondQuery.all
  end
  # 2차 쿼리 삭제
  def second_destroy
    @secondQuery = SecondQuery.find(params[:queryID])
    @sUserID = @secondQuery.sUserID
    @secondQuery.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/second_query", notice: "#{@sUserID}의 queryID = #{params[:queryID]} 2차 쿼리가 정상적으로 삭제되었습니다." }
    end
  end
  # for second_query_tags 테이블. 삭제, 수정 모두 불가능함. 삭제하고 싶다면 1차 쿼리 리스트에서 같은 queryID를 삭제
  # 1차 쿼리 태그 리스트 보기
  def second_tag_index
    @tags = SecondQueryTag.all
  end
  def second_query_survey_index
    @secondQuerySurveys = SecondQuerySurvey.all
  end
  def second_query_survey_edit
    @secondQuerySurvey = SecondQuerySurvey.where("queryID = #{params[:queryID]} AND shotID = #{params[:shotID]}")[0]
  end
  def second_query_survey_update
    @secondQuerySurvey = SecondQuerySurvey.where("queryID = #{params[:second_query_survey][:queryID]} AND shotID = #{params[:second_query_survey][:shotID]}")[0]
        
    respond_to do |format|
      if @secondQuerySurvey.update(second_params)
        format.html { redirect_to "/admin/second_query_survey", notice: "쿼리아이디 = #{@secondQuerySurvey.queryID}, 샷아이디 = #{@secondQuerySurvey.shotID} 설문이 정상적으로 수정되었습니다." }
      else
        format.html { render :second_query_survey_edit }
      end
    end
  end
  
  private
    # 1차 쿼리
    def first
      # First_Queries 데이터 추가
      @firstQuery = FirstQuery.new
      @firstQuery.sUserID = session[:user_id]
      @query = JSON.parse request.GET[:data]
      # "type" => "json" 제거
      @query.delete("type")
      # value가 ""(공백)인 값 제거
      @query = @query.reject { |key, value| value.empty? }
      @firstQuery.query = @query 
        
      if @firstQuery.save # 데이터베이스에 잘 저장 되었다면
        # response 만들기
        get_query_data
        
        begin
          @data = JSON.parse @data
          @data.each do |shot|
            @shotInfo = ShotInfo.where("ShotID = #{shot['ShotID'].to_i}")[0]
            if @shotInfo
              @video = Clist.find(@shotInfo.CID)
              @shotIDList.push shot['ShotID'].to_i
              @startTime = @shotInfo.StartFrame.split(":")
              @startTimeList.push ((@startTime[0].to_i * 3600) + (@startTime[1].to_i * 60) + (@startTime[2].to_i))
              @endTime = @shotInfo.EndFrame.split(":")
              @endTimeList.push ((@endTime[0].to_i * 3600) + (@endTime[1].to_i * 60) + (@endTime[2].to_i))
              @videoURLList.push @video.VideoURL.split("/").last
              @thumbList.push @shotInfo.ThumbURL
              @totalScoreList.push shot['TotalScore']
              @queryIDList.push @firstQuery.queryID
              
              # query Tag 저장
              shot['TagList'].each do |firstQueryTag|
                @firstQueryTag = FirstQueryTag.new
                @firstQueryTag.queryID = @firstQuery.queryID
                # 쿼리 받으면 수정 필요
                @firstQueryTag.shotID = shot['ShotID'].to_i
                @firstQueryTag.tagDesc = firstQueryTag['TagDesc']
                @firstQueryTag.tagID = firstQueryTag['TagID']
                @firstQueryTag.tagScore = firstQueryTag['TagSCore']
                unless @firstQueryTag.save # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
                  render 'get_page'
                end
              end
            end
          end
        rescue JSON::ParserError => e
          render 'get_page'
        end
      else # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
        render 'get_page'
      end
    end
    
    # 2차 쿼리
    def second    
      # Second_Queries 데이터 추가
      @secondQuery = SecondQuery.new
      @secondQuery.sUserID = session[:user_id]
      @query = JSON.parse request.GET[:data]
      # "type" => "json" 제거
      @query.delete("type")
      # value가 ""(공백)인 값 제거
      @query = @query.reject { |key, value| value.empty? }
      @secondQuery.query = @query
      if @secondQuery.save # 데이터베이스에 잘 저장 되었다면
        # response 만들기
        get_query_data
        
        begin
          @data = JSON.parse @data
          @data.each do |shot|
            @shotInfo = ShotInfo.where("ShotID = #{shot['ShotID'].to_i}")[0]
            if @shotInfo
              @video = Clist.find(@shotInfo.CID)
              @shotIDList.push shot['ShotID'].to_i
              @startTime = @shotInfo.StartFrame.split(":")
              @startTimeList.push ((@startTime[0].to_i * 3600) + (@startTime[1].to_i * 60) + (@startTime[2].to_i))
              @endTime = @shotInfo.EndFrame.split(":")
              @endTimeList.push ((@endTime[0].to_i * 3600) + (@endTime[1].to_i * 60) + (@endTime[2].to_i))
              @videoURLList.push @video.VideoURL.split("/").last
              @thumbList.push @shotInfo.ThumbURL
              @totalScoreList.push shot['TotalScore']
              @queryIDList.push @secondQuery.queryID
                      
              # query Tag 저장
              shot['TagList'].each do |secondQueryTag|
                @secondQueryTag = SecondQueryTag.new
                @secondQueryTag.queryID = @secondQuery.queryID
                # 쿼리 받으면 수정 필요
                @secondQueryTag.shotID = shot['ShotID'].to_i
                @secondQueryTag.tagDesc = secondQueryTag['TagDesc']
                @secondQueryTag.tagID = secondQueryTag['TagID']
                @secondQueryTag.tagScore = secondQueryTag['TagSCore']
                unless @secondQueryTag.save # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
                  render 'get_page'
                end
              end
            end
          end
        rescue JSON::ParserError => e
          render 'get_page'
        end
      else # 데이터베이스에 저장 실패할 경우 다시 1차 쿼리 페이지
        render 'get_page'
      end
    end
    
    # 1, 2차 쿼리 http(다이스트) 통신하기!
    def get_query_data
      # 다이퀘스트에 쿼리 보내기
      @queryStr = ""
      @query.each {|key, value| @queryStr += URI.encode("#{key.downcase}=#{value}&")}
      url = URI.parse("http://58.72.188.33:8080/pm/search.do?" + @queryStr + "currentpage=1&pagesize=10")
      req = Net::HTTP::Get.new(url.to_s)
      @res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      
      # response 파싱
      @data = @res.body.force_encoding("utf-8").gsub("\n", '')
      @data = @data.gsub("\t", '')
      @data = @data.gsub('\\', '')
      @data = @data.gsub('\"', '"')
      @data = "[" + @data[@data.index('{'), @data.size + 1]
        
      @shotIDList = Array.new
      @startTimeList = Array.new
      @endTimeList = Array.new
      @videoURLList = Array.new
      @totalScoreList = Array.new
      @thumbList = Array.new
      @queryIDList = Array.new
    end
    
    # 1차 쿼리 설문 form 파라미터들
    def first_params
      params.require(:first_query_survey).permit(:queryID, :shotID, :correct, :preference, :reason, :isSelect)
    end
    
    # 2차 쿼리 설문 form 파라미터들
    def second_params
      params.require(:second_query_survey).permit(:queryID, :shotID, :correct, :similarity, :preference, :reason, :isSelect)
    end
  end