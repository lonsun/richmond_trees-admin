json.array!(@adoption_requests) do |adoption_request|
  json.extract! adoption_request, :id
  json.url adoption_request_url(adoption_request, format: :json)
end
