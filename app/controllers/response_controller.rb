class ResponseController < ApplicationController
  def test
    @users = User.all
    request.format = :json
    respond_to do |format|
      format.json { render :json => @users }
    end
  end
end
