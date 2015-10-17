json.array!(@cars) do |car|
  json.extract! car, :license_plate_number, :name, :seats, :owner_email
  json.url car_url(car, format: :json)
end
