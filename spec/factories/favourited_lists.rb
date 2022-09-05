FactoryBot.define do
  factory :favourited_list do
    user
    association  :list
  end
end