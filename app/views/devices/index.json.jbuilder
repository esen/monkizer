json.array!(@devices) do |device|
  json.extract! device, :id, :model, :version, :adb_device_id, :project_id
  json.url device_url(device, format: :json)
end
