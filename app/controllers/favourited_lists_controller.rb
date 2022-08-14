class FavouritedListsController < ApplicationController

  def index
    favourited_lists = current_user.favourited_lists
    favourited_lists_with_details = favourited_lists.map do |list|
      List.find_by(id: list.list_id)
    end
    @favourited_lists_with_items = favourited_lists_with_details.map do |list|
      items = ListItem.where(list_id: list.id)
      items_with_names = items.map do |item|
        product = Product.find_by(id: item.product_id)
        { name: product.name, quantity: item.quantity }
      end

      { title: list.title, items: items_with_names}
    end
  end
end