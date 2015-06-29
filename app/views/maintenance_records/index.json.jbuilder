json.array!(@maintenance_records) do |maintenance_record|
  json.extract! maintenance_record, :id
  json.url maintenance_record_url(maintenance_record, format: :json)
end
