require 'pry'

class PublishedListsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    published_lists = List.where(published: true)
    @lists_with_items = published_lists.map do |list|
      items = ListItem.where(list_id: list.id)
      items_with_names = items.map do |item|
        product = Product.find_by(id: item.product_id)
        { name: product.name, quantity: item.quantity }
      end

      { title: list.title, items: items_with_names }
    end
  end
end
