class FilteringsController < ApplicationController
  before_action :set_filtering, only: [:show, :edit, :update, :destroy]
  # for InvalidAuthenticityToken
  skip_before_filter :verify_authenticity_token

  # GET /filterings
  # GET /filterings.json
  def index
    @filterings = Filtering.all
  end

  # GET /filterings/1
  # GET /filterings/1.json
  def show
  end

  # GET /filterings/new
  # GET /filtering
  def new
    @filtering = Filtering.new
  end

  # GET /filterings/1/edit
  def edit
    @filtering = Filtering.find(params[:sUserID])
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

  # POST /filterings
  # POST /filterings.json
  def create
    @filtering = Filtering.new(filtering_params)
    @filtering.sUserID = session[:user_id]
          
    if @filtering.save
      redirect_to "/first"
    else
      render 'new'
    end
  end

  # PATCH/PUT /filterings/1
  # PATCH/PUT /filterings/1.json
  def update  
    respond_to do |format|
      if @filtering.update(filtering_params)
        format.html { redirect_to "/admin/filterings", notice: "#{@filtering.sUserID}의 필터링이 정상적으로 수정되었습니다." }
        format.json { render :show, status: :ok, location: @filtering }
      else
        format.html { render :edit }
        format.json { render json: @filtering.errors, status: :unprocessable_entity }
      end
    end
  end

  # 관리자 필터링 삭제
  def destroy
    @sUserID = @filtering.sUserID
    @filtering.destroy
    respond_to do |format|
      format.html { redirect_to "/admin/filterings", notice: "#{@sUserID}의 필터링이 정상적으로 삭제되었습니다." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filtering
      @filtering = Filtering.find(params[:sUserID])
    end

    # filtering form 파라미터들
    def filtering_params
      params.require(:filtering).permit(:serviceProvider, :degree, :price)
    end
end
