require 'fileutils'

class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
    @json_file = ""
  end

  # GET /devices/1/edit
  def edit
    @json_file = File.read(Rails.root.to_s + "/config/device_configs/device_#{@device.id}.json")
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)
    @device.project = @project

    respond_to do |format|
      if @device.save
        File.open(Rails.root.to_s + "/config/device_configs/device_#{@device.id}.json","w") do |f|
          f.write(params[:configs])
        end 
        format.html { redirect_to [@project, @device], notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        File.open(Rails.root.to_s + "/config/device_configs/device_#{@device.id}.json","w") do |f|
          f.write(params[:configs])
        end 
        format.html { redirect_to [@project, @device], notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    if File.exist?(Rails.root.to_s + "/config/device_configs/device_#{@device.id}.json")
      File.delete(Rails.root.to_s + "/config/device_configs/device_#{@device.id}.json") 
    end

    respond_to do |format|
      format.html { redirect_to [@project, :devices], notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:model, :version, :adb_device_id, :project_id)
    end

    def set_project
      @project = Project.find(params[:project_id])
    end
end
