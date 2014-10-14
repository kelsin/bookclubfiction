json.partial! 'partials/user', :user => vote.user
json.extra vote.extra
json.value vote.value
json.created_at vote.created_at
json.updated_at vote.updated_at
