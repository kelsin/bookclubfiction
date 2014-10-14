# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    association :user, :factory => :member

    factory :extra_vote do
      extra true
    end
  end
end
