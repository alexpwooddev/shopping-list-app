class List < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :user
  has_many :list_items, dependent: :destroy
  has_many :products, through: :list_items
  validates :title, presence: true
end
