json.array!(@requests) do |request|
  json.extract! request, :requester_username, :status, :offer_datetime, :offer_car_license_plate_number
  json.url request_url(request, format: :json)
end
