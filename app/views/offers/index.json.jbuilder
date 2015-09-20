json.array!(@offers) do |offer|
  json.extract! offer, :id, :datetime, :pickUpPoint, :dropOffPoint, :vacancies, :car_id
  json.url offer_url(offer, format: :json)
end
