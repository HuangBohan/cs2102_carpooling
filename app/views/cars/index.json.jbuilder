json.array!(@cars) do |car|
  json.extract! car, :id, :name, :seats, :user_id
  json.url car_url(car, format: :json)
end
