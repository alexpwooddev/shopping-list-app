class ListItem < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :product
  belongs_to :list
  validates :quantity, presence: true
end
