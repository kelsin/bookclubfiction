json.id nomination.id
json.value nomination.value
json.admin nomination.admin
json.winner nomination.winner

json.vote nomination.voted?(current_user)
json.vote_created_at nomination.vote_created_at(current_user)
json.extra nomination.extra?(current_user)
json.extra_created_at nomination.extra_created_at(current_user)

json.votes nomination.votes.size
json.extras nomination.extras.size

json.book do
  json.partial! 'partials/book', :book => nomination.book
end

json.created_at nomination.created_at
json.updated_at nomination.updated_at
