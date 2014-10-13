json.ignore_nil!

json.logged_in current_user.present?
if current_user.present?
  json.user do
    json.name current_user.name
    json.uid current_user.uid
    json.extra_votes current_user.extra_votes
    json.image current_user.image
  end
  json.current @current
end
