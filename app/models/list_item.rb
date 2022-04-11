class ListItem < ApplicationRecord
  belongs_to :product
  belongs_to :list
end
