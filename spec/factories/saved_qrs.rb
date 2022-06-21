FactoryBot.define do
  factory :saved_qr do
    quantity { 1 }
    user
    association :product
  end
end
