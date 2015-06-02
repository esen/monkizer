class CommonController < ApplicationController
  def get_adb_ids
    cmd = ENV['ADB_PATH'] + " devices"
    devices = `#{cmd}`
    render json: {devices: devices}, content_type: "application/json"
  end
end
