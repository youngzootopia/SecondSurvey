require 'net/http'

class SecondController < ApplicationController
  # for InvalidAuthenticityToken
  skip_before_filter :verify_authenticity_token
  
  # 설문 페이지
  def get_page
    @user = User.find(session[:user_id])
    unless Filtering.exists? @user.sUserID
      redirect_to "/filtering" 
    end
  end
  
  # 1차 쿼리 정보 요청할 떄
  def get_json
    get_query_data
    
    request.format = :json
    respond_to do |format|
    format.json { render :json => [shotIDList: @shotIDList, startTimeList: @startTimeList, endTimeList: @endTimeList, videoURLList: @videoURLList, totalScoreList: @totalScoreList, queryIDList: @queryIDList] }
    end
  end
  
  # 설문 결과 저장하고 정보 전송
  def survey_commit

  end
  
  private
    # 검색 쿼리 http 통신하기.
    def get_query_data
      url = URI.parse("http://58.72.188.33:8080/lod/search.do?MAXSHOT=10" + "&type=json")
      req = Net::HTTP::Get.new(url.to_s)
      @res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      
      # response!!! 파싱 필요!!!
      # puts res.body
      # 임시 데이터
      @shotIDList = Array.new
      @shotIDList.push 1362 # 70 30
      @shotIDList.push 1378 # 77 24
      @startTimeList = Array.new
      @startTimeList.push 4.7
      @startTimeList.push 13.833333
      @endTimeList = Array.new
      @endTimeList.push 7.4666666
      @endTimeList.push 18.79166666
      @videoURLList = Array.new
      @videoURLList.push "bic_070.mp4"
      @videoURLList.push "bic_077.mp4"
      @totalScoreList = Array.new
      @totalScoreList.push 1
      @totalScoreList.push 3
      @queryIDList = Array.new
      @queryIDList.push 123
      @queryIDList.push 123
    end
end
