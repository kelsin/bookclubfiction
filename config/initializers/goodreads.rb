module Goodreads
  module Request
    API_URL    = 'https://www.goodreads.com'
  end
end

Goodreads.configure(:api_key => ENV['GOODREADS_KEY'],
                    :api_secret => ENV['GOODREADS_SECRET'])
