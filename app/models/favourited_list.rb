class FavouritedList < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :user
  belongs_to :list
  validates :list, uniqueness: { scope: :list, message: "a list can only be added once"}
end