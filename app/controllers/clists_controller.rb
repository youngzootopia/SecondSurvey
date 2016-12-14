class ClistsController < ApplicationController
  before_action :set_clist, only: [:show, :edit, :update, :destroy]

  # GET /clists
  # GET /clists.json
  def index
    @clists = Clist.all
  end

  # GET /clists/1
  # GET /clists/1.json
  def show
  end

  # GET /clists/new
  def new
    @clist = Clist.new
  end

  # GET /clists/1/edit
  def edit
  end

  # POST /clists
  # POST /clists.json
  def create
    @clist = Clist.new(clist_params)

    respond_to do |format|
      if @clist.save
        format.html { redirect_to @clist, notice: 'Clist was successfully created.' }
        format.json { render :show, status: :created, location: @clist }
      else
        format.html { render :new }
        format.json { render json: @clist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clists/1
  # PATCH/PUT /clists/1.json
  def update
    respond_to do |format|
      if @clist.update(clist_params)
        format.html { redirect_to @clist, notice: 'Clist was successfully updated.' }
        format.json { render :show, status: :ok, location: @clist }
      else
        format.html { render :edit }
        format.json { render json: @clist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clists/1
  # DELETE /clists/1.json
  def destroy
    @clist.destroy
    respond_to do |format|
      format.html { redirect_to clists_url, notice: 'Clist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clist
      @clist = Clist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clist_params
      params.require(:clist).permit(:CID, :Category, :ProgramName, :EpisodeNum, :VideoURL, :VideoFileName, :VideoThumb, :FPS, :RegisterDateTime, :LastSavedDateTime, :TagStatus, :User, :ProgramNameKor)
    end
end
