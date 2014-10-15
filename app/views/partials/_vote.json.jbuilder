json.extra vote.extra
json.value vote.value

json.user do
  json.partial! 'partials/user', :user => vote.user
end

json.created_at vote.created_at
json.updated_at vote.updated_at
