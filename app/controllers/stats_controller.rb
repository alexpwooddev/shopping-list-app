require 'pry'

class StatsController < ApplicationController
  def index
    @top_products_by_quantity = top_n_products_by_quantity(3)
    @top_products_by_list_occurrence = top_n_products_by_list_occurrence(3)
  end


  private

  # users top n products by quantity across all lists
  def top_n_products_by_quantity(n)
    list_items = user_list_items
    sort_products(n, list_items)
  end

  # a user's top n products by number of occurrences as a list_item
  def top_n_products_by_list_occurrence(n)
    list_items = user_list_items
    items_grouped_by_product = group_items_by_product(list_items)
    product_occurrences_with_id = sum_product_occurrences(items_grouped_by_product)
    product_occurrences_with_name = convert_products_with_id_to_name(product_occurrences_with_id)
    sort_n_summed_products(n, product_occurrences_with_name)
  end

  def user_list_items
    user_lists = current_user.lists
    user_list_items = user_lists.map do |list|
      list.list_items.map { |item| item }
    end
    user_list_items.flatten(1)
  end
  
  def group_items_by_product(list_items)
    list_items.group_by { |item| item['product_id'] }
  end

  def sum_products_by_quantity(list_items)
    group_items_by_product(list_items).map do |group|
      [group[0], group[1].map(&:quantity).inject(0, &:+)]
    end
  end

  def sum_product_occurrences(items_grouped_by_product)
    items_grouped_by_product.map do |product_id, item_array|
      [product_id, item_array.length]
    end
  end

  def convert_products_with_id_to_name(products_with_id)
    products_with_id.map do |product|
      [Product.find_by(id: product[0]).name , product[1]]
    end
  end

  def sort_n_summed_products(n, summed_products)
    summed_products.sort_by { |product| product[1] }.reverse!.first(n)
  end

  def sort_products(n, list_items)
    product_sums = sum_products_by_quantity(list_items)
    top_n_products_with_id = sort_n_summed_products(n, product_sums)
    convert_products_with_id_to_name(top_n_products_with_id)
  end
end
