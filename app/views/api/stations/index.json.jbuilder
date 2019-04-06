json.array!(@stations) do |station|
  json.id   station.id
  json.name station.name
  json.comuna station.comuna&.name
  json.location({longitude: station.location.lon, latitude: station.location.lat})
end