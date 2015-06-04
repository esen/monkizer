class BuildResultsController < ApplicationController
  before_action :set_build_result, only: [:show, :destroy]
  before_action :set_project
  before_action :set_build

  # GET /build_results
  # GET /build_results.json
  def index
    @build_results = BuildResult.of_build(@build)
  end

  # GET /build_results/1
  # GET /build_results/1.json
  def show
    @logs = File.read(@build_result.log_file)
  end

  def destroy
    counter = 0
    killed = true

    if @build_result.pid
      begin
        counter = counter + 1
        puts counter
        begin
          Process.kill("TERM", @build_result.pid)
        rescue Exception => e
          puts e.message
          killed = false if e.message != "No such process"
        end
        puts killed
      end until killed || counter > 5
    end

    @build_result.destroy if killed
    redirect_to [@project, @build, :build_results]
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

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_build
      @build = Build.find(params[:build_id])
    end
  end
