class BuildResultsController < ApplicationController
  before_action :set_build_result, only: [:show, :edit, :update, :destroy]

  # GET /build_results
  # GET /build_results.json
  def index
    @build_results = BuildResult.all
  end

  # GET /build_results/1
  # GET /build_results/1.json
  def show
  end

  # GET /build_results/new
  def new
    @build_result = BuildResult.new
  end

  # GET /build_results/1/edit
  def edit
  end

  # POST /build_results
  # POST /build_results.json
  def create
    @build_result = BuildResult.new(build_result_params)

    respond_to do |format|
      if @build_result.save
        format.html { redirect_to @build_result, notice: 'Build result was successfully created.' }
        format.json { render :show, status: :created, location: @build_result }
      else
        format.html { render :new }
        format.json { render json: @build_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /build_results/1
  # PATCH/PUT /build_results/1.json
  def update
    respond_to do |format|
      if @build_result.update(build_result_params)
        format.html { redirect_to @build_result, notice: 'Build result was successfully updated.' }
        format.json { render :show, status: :ok, location: @build_result }
      else
        format.html { render :edit }
        format.json { render json: @build_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /build_results/1
  # DELETE /build_results/1.json
  def destroy
    @build_result.destroy
    respond_to do |format|
      format.html { redirect_to build_results_url, notice: 'Build result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_build_result
      @build_result = BuildResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_result_params
      params.require(:build_result).permit(:build_id, :device_id, :passed, :log_file)
    end
end
