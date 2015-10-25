json.array!(@offers) do |offer|
  json.extract! offer, :datetime, :pickUpPoint, :dropOffPoint, :vacancies, :car_license_plate_number
  json.url offer_url(offer, format: :json)
end
