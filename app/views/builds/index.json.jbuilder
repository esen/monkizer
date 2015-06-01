json.array!(@builds) do |build|
  json.extract! build, :id, :project_id, :ci_build_number
  json.url build_url(build, format: :json)
end
