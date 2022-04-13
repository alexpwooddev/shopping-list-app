require 'rails_helper'

RSpec.describe ListItem, type: :model do

  describe "creation" do
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    it "can be created" do
      list = user_with_lists_with_items.lists.first
      list_item = list.list_items.first
      expect(list_item).to be_valid
    end
  end

  describe "validations" do
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    it "should have a quantity" do
      list = user_with_lists_with_items.lists.first
      list_item = list.list_items.first
      list_item.quantity = nil
      expect(list_item).to_not be_valid
    end
  end

  describe "default values" do
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    it "should have quantity set to 1" do
      list = user_with_lists_with_items.lists.first
      list_item = list.list_items.first
      expect(list_item.quantity).to eq(1)
    end
  end

  describe "order scope" do
    let!(:user_with_lists_with_items_diff_age) { FactoryBot.create(:user_with_lists_with_items_diff_age) }
    it "short sort list items in descending order" do
      list = user_with_lists_with_items_diff_age.lists.first
      first_list_item = list.list_items.first
      second_list_item = list.list_items.second
      puts first_list_item.created_at
      puts second_list_item.created_at
      expect(first_list_item.created_at).to be > second_list_item.created_at
    end
  end

end
