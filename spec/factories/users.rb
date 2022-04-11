FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { "password" }

    factory :user_with_lists do
      transient do
        lists_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:list, evaluator.lists_count, user: user)
      end
    end

    factory :user_with_completed_lists do
      transient do
        lists_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:completed_list, evaluator.lists_count, user: user)
      end
    end

  end
end
