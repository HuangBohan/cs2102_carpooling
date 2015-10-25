json.array!(@users) do |user|
  json.extract! user, :username, :name, :isAdmin, :credits
  json.url user_url(user, format: :json)
end
