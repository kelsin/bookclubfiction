# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :selection do
    association :user, :factory => :random_member
    round
    book
  end
end
