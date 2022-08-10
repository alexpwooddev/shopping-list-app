FactoryBot.define do
  factory :user do
    email { "user-1@example.com" }
    password { "password" }
    id { 1 }

    factory :user_with_lists do
      transient do
        lists_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:list, evaluator.lists_count, user: user)
      end
    end

    factory :user_with_lists_with_items do
      transient do
        lists_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:list_with_items, evaluator.lists_count, user: user)
      end
    end

    factory :user_with_lists_with_items_diff_age do
      transient do
        lists_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:list_with_items_diff_age, evaluator.lists_count, user: user)
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

    factory :user_with_saved_qrs do
      transient do
        saved_qrs_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:saved_qr, evaluator.saved_qrs_count, user: user)
      end
    end

    factory :user_with_favourited_lists do
      transient do
        favourited_lists_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:favourited_list, evaluator.favourited_lists_count, user: user)
      end
    end

  end

  factory :another_user do
    email { "user-2@example.com" }
    password { "password" }
    id { 2 }
  end
end
