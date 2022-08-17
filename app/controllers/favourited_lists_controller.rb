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

  def create
    list = List.find(params[:id])
    favourited_list = FavouritedList.new(user: current_user, list: list)

    if favourited_list.save
      flash[:success] = "List added to favourites"
      redirect_to(favourited_lists_path)
    else
      flash[:warn] = "There was a problem adding that list - you might have previously added it"
      redirect_to(published_lists_path)
    end
  end
end