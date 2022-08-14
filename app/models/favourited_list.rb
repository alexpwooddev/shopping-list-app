class FavouritedList < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :user
  belongs_to :list
end