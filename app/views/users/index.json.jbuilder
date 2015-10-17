json.array!(@users) do |user|
  json.extract! user, :email, :name, :isAdmin, :credits
  json.url user_url(user, format: :json)
end
