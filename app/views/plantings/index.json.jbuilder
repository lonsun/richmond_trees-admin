json.array!(@plantings) do |planting|
  json.extract! planting, :id
  json.url planting_url(planting, format: :json)
end
