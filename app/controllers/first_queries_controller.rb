class FirstQueriesController < ApplicationController
  before_action :set_first_query, only: [:show, :edit, :update, :destroy]

  # GET /first_queries
  # GET /first_queries.json
  def index
    @first_queries = FirstQuery.all
  end

  # GET /first_queries/1
  # GET /first_queries/1.json
  def show
  end

  # GET /first_queries/new
  def new
    @first_query = FirstQuery.new
  end

  # GET /first_queries/1/edit
  def edit
  end

  # POST /first_queries
  # POST /first_queries.json
  def create
    @first_query = FirstQuery.new(first_query_params)

    respond_to do |format|
      if @first_query.save
        format.html { redirect_to @first_query, notice: 'First query was successfully created.' }
        format.json { render :show, status: :created, location: @first_query }
      else
        format.html { render :new }
        format.json { render json: @first_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /first_queries/1
  # PATCH/PUT /first_queries/1.json
  def update
    respond_to do |format|
      if @first_query.update(first_query_params)
        format.html { redirect_to @first_query, notice: 'First query was successfully updated.' }
        format.json { render :show, status: :ok, location: @first_query }
      else
        format.html { render :edit }
        format.json { render json: @first_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /first_queries/1
  # DELETE /first_queries/1.json
  def destroy
    @first_query.destroy
    respond_to do |format|
      format.html { redirect_to first_queries_url, notice: 'First query was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_first_query
      @first_query = FirstQuery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def first_query_params
      params.require(:first_query).permit(:sUserID, :queryID, :query)
    end
end
