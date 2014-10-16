json.query @response.query
json.source @response.source
json.results_start @response.results_start
json.results_end @response.results_end
json.total_results @response.total_results

if @response.total_results.to_i > 0
  if @response.results.work.is_a? Array
    works = Array(@response.results.work)
  else
    works = [@response.results.work]
  end
else
  works = []
end

json.books works do |work|
  json.goodreads_id work.best_book.id
  json.title work.best_book.title
  json.rating work.average_rating
  json.author work.best_book.author.name
  json.image work.best_book.image_url
  json.small_image work.best_book.small_image_url
  json.url "https://www.goodreads.com/book/show/#{work.best_book.id}"
end
