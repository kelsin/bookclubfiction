json.user do
  json.partial! 'partials/user', :user => current_user
end

json.round do
  json.partial! 'partials/round', :round => @round
end
