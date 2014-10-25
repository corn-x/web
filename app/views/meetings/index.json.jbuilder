json.array!(@meetings) do |meeting|
  json.extract! meeting, :id
  json.extract! meeting, :time_ranges
  json.extract! meeting, :creator
  json.extract! meeting, :where
  json.extract! meeting, :description
  json.extract! meeting, :start_time
  json.extract! meeting, :end_time
  json.extract! meeting, :name
  json.extract! meeting, :scheduled?
  json.url meeting_url(meeting, format: :json)
end
