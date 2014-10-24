json.extra_votes current_user.extra_votes

json.nomination do
  json.current Time.now.to_i
  json.vote @nomination.voted?(current_user)
  json.vote_created_at @nomination.vote_created_at(current_user)
  json.extra @nomination.extra?(current_user)
  json.extra_created_at @nomination.extra_created_at(current_user)
end
