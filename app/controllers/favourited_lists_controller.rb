class FavouritedListsController < ApplicationController

  def index
    favourited_lists = current_user.favourited_lists
    favourited_lists_with_lists = get_favourited_lists_with_lists(favourited_lists)
    @favourited_lists_with_items = get_favourited_lists_with_items(favourited_lists_with_lists)
  end

  def create
    favourited_list = FavouritedList.new(user: current_user, list: List.find(params[:id]))

    if favourited_list.save
      flash[:success] = "List added to favourites"
      redirect_to(favourited_lists_path)
    else
      flash[:warn] = "There was a problem adding that list - you might have previously added it"
      redirect_to(published_lists_path)
    end
  end

  def destroy
    favourited_list = FavouritedList.find(params[:id])
    if authorized?(favourited_list)
      favourited_list.destroy
      flash[:success] = "List removed"
      redirect_to(favourited_lists_path)
    else
      handle_unauthorized
    end

  end


  private


  def get_favourited_lists_with_lists(favourited_lists)
    favourited_lists.map do |favourited_list|
      {
        favourited_list: favourited_list,
        list: List.find_by(id: favourited_list.list_id)
      }
    end
  end

  def get_favourited_lists_with_items(favourited_lists_with_lists)
    favourited_lists_with_lists.map do |fav_list_with_list|
      items = ListItem.where(list_id: fav_list_with_list[:list].id)
      items_with_names = items.map do |item|
        product = Product.find_by(id: item.product_id)
        { name: product.name, quantity: item.quantity }
      end

      { title: fav_list_with_list[:list].title,
        items: items_with_names,
        favourited_list_id: fav_list_with_list[:favourited_list].id }
    end
  end

  def authorized?(favourited_list)
    favourited_list.user == current_user
  end

  def handle_unauthorized
    flash[:warn] = "You aren't authorized to do that"
  end

end
