# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nomination do
    association :user, :factory => :random_member
    winner false
    round
    book

    factory :admin_nomination do
      admin true
    end

    factory :winning_nomination do
      winner true
    end
  end
end
