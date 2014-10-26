json.array!(@calendars) do |calendar|
  json.extract! calendar, :id, :ext_id, :last_synced
  json.url calendar_url(calendar, format: :json)
end
