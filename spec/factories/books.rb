# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    sequence(:goodreads_id)
    sequence(:title) { |n| "Title #{n}" }
    rating { rand(0.0..5.0) }
    author "Author"
    image "image"
    small_image "small_image"
  end
end
