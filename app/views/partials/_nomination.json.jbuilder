json.id nomination.id
json.value nomination.value
json.admin nomination.admin

json.vote nomination.voted?(current_user)
json.extra nomination.extra?(current_user)

json.votes nomination.vote_user_ids.size
json.extras nomination.extra_user_ids.size

json.user do
  json.partial! 'partials/user', :user => nomination.user
end

json.book do
  json.partial! 'partials/book', :book => nomination.book
end

json.created_at nomination.created_at
json.updated_at nomination.updated_at
