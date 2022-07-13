require 'pry'

class StatsController < ApplicationController
  def index
    # get a user's top 3 products by number of occurrences as a list_item
    user_lists = current_user.lists

    user_list_items = user_lists.map do |list|
      list.list_items.map { |item| item }
    end
    user_list_items_flat = user_list_items.flatten(1)

    items_grouped_by_product = user_list_items_flat.group_by do |item|
      item['product_id']
    end

    product_sums = items_grouped_by_product.map do |group|
      group[1].map(&:quantity).inject(0, &:+)
    end

    binding.pry
  end


  private

  # this gets the highest quantity item from each list
  # NOT what I want...
  # user_lists.each do |list|
  #   list_items = list.list_items
  #   max_quantity_item = list_items.max_by{ |list_item| list_item.quantity }
  #   puts "max_quant_item", max_quantity_item
  # end


end
