class FilteringsController < ApplicationController
  # GET /filtering
  def new
    @filtering = Filtering.new
  end
  
  # POST /filtering
  def create
    @filtering = Filtering.new(filtering_params)
    @filtering.sUserID = session[:user_id]
          
    if @filtering.save
      render :controller_name => :first, :action_name => :get_page, :template => "first/get_page"
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
