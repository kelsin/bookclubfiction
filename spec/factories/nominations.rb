# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :nomination do
    association :user, :factory => :member
    round
    book

    factory :nomination_with_votes do
      votes { [FactoryGirl.build(:vote), FactoryGirl.build(:extra_vote)] }
    end
  end
end
