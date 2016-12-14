class ShotInfosController < ApplicationController
  before_action :set_shot_info, only: [:show, :edit, :update, :destroy]

  # GET /shot_infos
  # GET /shot_infos.json
  def index
    @shot_infos = ShotInfo.all
  end

  # GET /shot_infos/1
  # GET /shot_infos/1.json
  def show
  end

  # GET /shot_infos/new
  def new
    @shot_info = ShotInfo.new
  end

  # GET /shot_infos/1/edit
  def edit
  end

  # POST /shot_infos
  # POST /shot_infos.json
  def create
    @shot_info = ShotInfo.new(shot_info_params)

    respond_to do |format|
      if @shot_info.save
        format.html { redirect_to @shot_info, notice: 'Shot info was successfully created.' }
        format.json { render :show, status: :created, location: @shot_info }
      else
        format.html { render :new }
        format.json { render json: @shot_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shot_infos/1
  # PATCH/PUT /shot_infos/1.json
  def update
    respond_to do |format|
      if @shot_info.update(shot_info_params)
        format.html { redirect_to @shot_info, notice: 'Shot info was successfully updated.' }
        format.json { render :show, status: :ok, location: @shot_info }
      else
        format.html { render :edit }
        format.json { render json: @shot_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shot_infos/1
  # DELETE /shot_infos/1.json
  def destroy
    @shot_info.destroy
    respond_to do |format|
      format.html { redirect_to shot_infos_url, notice: 'Shot info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shot_info
      @shot_info = ShotInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shot_info_params
      params.require(:shot_info).permit(:ShotID, :ShotNum, :StartFrame, :EndFrame, :ThumbURL, :CID)
    end
end
