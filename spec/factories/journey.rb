# frozen_string_literal: true

FactoryBot.define do
  factory :journey do
    association :car, factory: :car
    group { association :group, waiting: false, people: 4 }

    trait :six_seats_full_book do
      association :car, factory: %i[car six_seats_booked]
      group { association :group, waiting: false, people: 6 }
    end

    trait :five_seats_full_book do
      association :car, factory: %i[car five_seats_booked]
      group { association :group, waiting: false, people: 5 }
    end
  end
end
