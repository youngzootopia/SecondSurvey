class FirstQueryTagsController < ApplicationController
  before_action :set_first_query_tag, only: [:show, :edit, :update, :destroy]

  # GET /first_query_tags
  # GET /first_query_tags.json
  def index
    @first_query_tags = FirstQueryTag.all
  end

  # GET /first_query_tags/1
  # GET /first_query_tags/1.json
  def show
  end

  # GET /first_query_tags/new
  def new
    @first_query_tag = FirstQueryTag.new
  end

  # GET /first_query_tags/1/edit
  def edit
  end

  # POST /first_query_tags
  # POST /first_query_tags.json
  def create
    @first_query_tag = FirstQueryTag.new(first_query_tag_params)

    respond_to do |format|
      if @first_query_tag.save
        format.html { redirect_to @first_query_tag, notice: 'First query tag was successfully created.' }
        format.json { render :show, status: :created, location: @first_query_tag }
      else
        format.html { render :new }
        format.json { render json: @first_query_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /first_query_tags/1
  # PATCH/PUT /first_query_tags/1.json
  def update
    respond_to do |format|
      if @first_query_tag.update(first_query_tag_params)
        format.html { redirect_to @first_query_tag, notice: 'First query tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @first_query_tag }
      else
        format.html { render :edit }
        format.json { render json: @first_query_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /first_query_tags/1
  # DELETE /first_query_tags/1.json
  def destroy
    @first_query_tag.destroy
    respond_to do |format|
      format.html { redirect_to first_query_tags_url, notice: 'First query tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_first_query_tag
      @first_query_tag = FirstQueryTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def first_query_tag_params
      params.require(:first_query_tag).permit(:queryID, :shotID, :tagDesc, :tagID, :tagScore)
    end
end
