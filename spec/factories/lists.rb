FactoryBot.define do
  factory :list do
    sequence(:title) { |n| "List #{n}" }
    user
    complete { false }

    factory :list_with_items do
      transient do
        items_count { 5 }
      end

      after(:create) do |list, evaluator|
        create_list(:list_item, evaluator.items_count, list: list)
      end
    end

    factory :list_with_items_diff_age do
      after(:create) do |list|
        create(:list_item, created_at: Time.now - 1.day, list: list)
        create(:list_item, created_at: Time.now + 1.day, list: list)
      end
    end

    factory :completed_list do
      complete { true }
    end
  end
end
