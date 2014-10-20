json.id vote.id
json.book do
  json.partial! 'partials/book', :book => vote.book
end
json.value vote.value
