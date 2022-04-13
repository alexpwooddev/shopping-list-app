FactoryBot.define do
  factory :list_item do
    quantity { 1 }
    list_id { 1 }
    association :product
  end
end
