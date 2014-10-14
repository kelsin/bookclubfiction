json.partial! 'partials/user', :user => nomination.user
json.partial! 'partials/book', :book => nomination.book
json.partial! 'partials/vote', :collection => nomination.votes, :as => :vote
json.value nomination.value
json.created_at nomination.created_at
json.updated_at nomination.updated_at
