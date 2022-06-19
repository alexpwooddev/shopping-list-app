class Product < ApplicationRecord
  has_many :list_items, dependent: :destroy
  has_many :saved_qrs, dependent: :destroy
  validates :name, presence: true
end
