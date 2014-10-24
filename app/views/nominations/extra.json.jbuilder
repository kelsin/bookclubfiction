json.extra_votes current_user.extra_votes

json.user do
  json.partial! 'partials/user', :user => current_user
end

json.round do
  json.partial! 'partials/round', :round => @round
end
