json.query @response.query
json.source @response.source
json.total_results @response.total_results
json.books @response.results.work do |work|
  json.id work.best_book.id
  json.title work.best_book.title
  json.rating work.average_rating
  json.author work.best_book.author.name
  json.image_url work.best_book.image_url
  json.small_image_url work.best_book.small_image_url
end
