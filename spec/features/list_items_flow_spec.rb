require 'rails_helper'

RSpec.feature "ListsFlows", type: :feature do

  describe "creating a list_item from search dropdown", js: true do
    let(:user) { FactoryBot.create(:user_with_lists_with_items) }
    it "creates a new item" do
      list = user.lists.first
      list_item = list.list_items.first
      starting_item_count = page.all(:css, 'table tr').size
      puts list_item.product_id
      login_as(user, :scope => :user)
      visit "lists/#{list.id}"
      find('#product-search').click
      find(".list-group-item:first-of-type").click
      ending_item_count = page.all(:css, 'table tr').size
      expect(starting_item_count).to be < ending_item_count
    end
  end


end
