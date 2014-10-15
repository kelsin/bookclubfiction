# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :round do
    genre 'Horror'
    state 'nominating'
    created_at { 20.minutes.ago }

    factory :seconding_round do
      state 'seconding'
      seconding_at { 15.minutes.ago }

      factory :reading_round do
        state 'reading'
        reading_at { 10.minutes.ago }

        factory :closed_round do
          state 'closed'
          closed_at { 5.minutes.ago }
        end
      end
    end
  end
end
