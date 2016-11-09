class FilteringsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  # GET /filtering
  def new
    @filtering = Filtering.new
  end
  
  # POST /filtering
  def create
    @filtering = Filtering.new(filtering_params)
    @filtering.sUserID = session[:user_id]
          
    if @filtering.save
      redirect_to "/first"
    else
      render 'new'
    end
  end

  private
    # filtering form 파라미터들
    def filtering_params
      params.require(:filtering).permit(:serviceProvider, :degree, :price)
    end
end
