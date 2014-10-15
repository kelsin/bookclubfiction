json.id selection.id

json.book do
  json.partial! 'partials/book', :book => selection.book
end

json.created_at selection.created_at
json.updated_at selection.updated_at
