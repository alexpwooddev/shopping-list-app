FactoryBot.define do
  factory :list do
    sequence(:title) { |n| "To Do Item #{n}" }
    user
    complete { false }

    factory :completed_list do
      complete { true }
    end
  end
end
