json.array!(@station_logs_aggregate) do |log|
  json.timestamp   log.timestamp
  json.free_bikes  log.total_free_bikes
  json.empty_slots log.total_empty_slots
end
