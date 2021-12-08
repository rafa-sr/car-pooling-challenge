# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    people { rand(1..6) }
    waiting { true }
    created_at { Time.now + rand(1..3600) }

    trait :first_group do
      created_at { Time.now - 3600 }
    end

    trait :first_group_four_ppl do
      people { 4 }
      created_at { Time.now - 3600 }
    end

    trait :first_group_six_ppl do
      people { 6 }
      created_at { Time.now - 3600 }
    end

    trait :not_waiting do
      waiting { false }
    end

    trait :one_ppl do
      people { 1 }
    end

    trait :two_ppl do
      people { 2 }
    end

    trait :three_ppl do
      people { 3 }
    end

    trait :four_ppl do
      people { 4 }
    end

    trait :five_ppl do
      people { 5 }
    end

    trait :six_ppl do
      people { 6 }
    end
  end
end
