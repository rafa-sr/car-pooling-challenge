# frozen_string_literal: true

FactoryBot.define do
  factory :car do
    sequence(:id)
    seats { rand(4..6) }
    available_seats { seats }

    trait :four_seats do
      seats { 4 }
      available_seats { seats }
    end

    trait :six_seats_booked do
      seats { 6 }
      available_seats { 0 }
    end

    trait :five_seats_booked do
      seats { 5 }
      available_seats { 0 }
    end
  end
end
