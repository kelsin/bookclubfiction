json.id nomination.id
json.value nomination.value
json.admin nomination.admin

json.user do
  json.partial! 'partials/user', :user => nomination.user
end

json.book do
  json.partial! 'partials/book', :book => nomination.book
end

json.votes nomination.votes, :partial => 'partials/vote', :as => :vote

json.created_at nomination.created_at
json.updated_at nomination.updated_at
