json.goodreads_id book.goodreads_id
json.title book.title
json.rating book.rating
json.author book.author
json.image book.image.sub(/^http:/, 'https:')
json.small_image book.small_image.sub(/^http:/, 'https:')
json.url book.url
