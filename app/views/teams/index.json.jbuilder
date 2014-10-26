json.array!(@teams) do |team|
  json.extract! team, :id
  json.extract! team, :name
  json.url team_url(team, format: :json)
  json.members team.members, :email, :first_name, :last_name
end
