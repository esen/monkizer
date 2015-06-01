json.array!(@build_results) do |build_result|
  json.extract! build_result, :id, :build_id, :device_id, :passed, :log_file
  json.url build_result_url(build_result, format: :json)
end
