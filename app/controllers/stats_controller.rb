require 'pry'

class StatsController < ApplicationController
  def index
    @top_products = top_n_products(3)
  end


  private

  # a user's top n products by number of occurrences as a list_item
  def top_n_products(n)
    list_items = user_list_items

    group_and_sort_products(n, list_items)
  end


  def user_list_items
    user_lists = current_user.lists

    user_list_items = user_lists.map do |list|
      list.list_items.map { |item| item }
    end

    user_list_items.flatten(1)
  end


  def group_and_sort_products(n, list_items)
    items_grouped_by_product = list_items.group_by { |item| item['product_id'] }

    product_sums = items_grouped_by_product.map do |group|
      [group[0], group[1].map(&:quantity).inject(0, &:+)]
    end

    top_n_products_with_id = product_sums.sort_by { |product| product[1] }.reverse!.first(n)
    top_n_products_with_name = top_n_products_with_id.map do |product|
      [Product.find_by(id: product[0]).name , product[1]]
    end

    top_n_products_with_name
  end
end
