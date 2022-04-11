class Product < ApplicationRecord
  has_many :list_items, dependent: :destroy
  validates :name, presence: true
end
