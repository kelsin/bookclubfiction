json.logged_in current_user.present?

json.user do
  json.partial! 'partials/user', :user => current_user
end if current_user

json.current do
  json.partial! 'partials/round', :round => @current
end if @current
