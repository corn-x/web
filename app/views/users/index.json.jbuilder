json.array!(@users) do |user|
  json.extract! user, :id
  json.extract! user, :email
  json.extract! user, :first_name
  json.extract! user, :last_name
  json.url user_url(user, format: :json)
end
