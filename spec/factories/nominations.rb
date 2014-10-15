# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nomination do
    association :user, :factory => :random_member
    round
    book

    factory :admin_nomination do
      admin true
    end
  end
end
