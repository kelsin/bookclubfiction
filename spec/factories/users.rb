# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :uid

  sequence :access_token do |n|
    "access_token_#{n}"
  end

  sequence :access_token_secret do |n|
    "access_token_secret_#{n}"
  end

  factory :user do
    uid { generate(:uid) }
    provider 'goodreads'
    sequence(:name) { |n| "User #{n}" }
    access_token { generate(:access_token) }
    access_token_secret { generate(:access_token_secret) }

    factory :member do
      sequence(:name) { |n| "Member #{n}" }
      member true

      factory :admin do
        sequence(:name) { |n| "Admin #{n}" }
        admin true
      end
    end
  end
end
