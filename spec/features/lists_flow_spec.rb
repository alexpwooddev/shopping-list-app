require 'rails_helper'

RSpec.feature "ListsFlows", type: :feature do
  describe "creating a list", js: true do
    let(:user) { FactoryBot.create(:user) }
    valid_list = 'this is a new note'
    in_valid_list = ''
    it "creates a new list on the top of the list" do
      login_as(user, :scope => :user)
      visit root_path
      fill_in('title', with: valid_list)
      click_button('Add List')
      new_list = find('.table > tbody > tr:first-of-type td:nth-child(2) input:first-of-type')
      expect(new_list.value).to eq(valid_list)
    end
  end

  describe "updating a list", js: true do
    let(:user_with_lists) { FactoryBot.create(:user_with_lists) }
    updated_list_text = 'updated'
    context "list is valid" do
      it "updates the list" do
        login_as(user_with_lists, :scope => :user)
        visit root_path
        list = user_with_lists.lists.first
        find("#list__title-#{list.id}").send_keys(updated_list_text)
        sleep 2
        visit root_path
        updated_list = find('.table > tbody > tr:first-of-type td:nth-child(2) input:first-of-type')
        expect(updated_list.value).to eq(list.title + updated_list_text)
      end
    end
    context "list is invalid", js: true do
      it "displays an error message" do
        login_as(user_with_lists, :scope => :user)
        visit root_path
        list = user_with_lists.lists.first
        fill_in("list__title-#{list.id}", with: "")
        expect(page).to have_content("can't be blank")
      end
    end    
  end

  describe "deleting a list", js: true do
    let(:user_with_lists) { FactoryBot.create(:user_with_lists) }
    it "removes the list from the list" do
      login_as(user_with_lists, :scope => :user)
      visit root_path
      list = user_with_lists.lists.first
      row = find(".table > tbody > tr:first-of-type td:nth-child(3)")
      accept_confirm do
        row.click_button("Delete")
      end
      expect(page).to_not have_content(list.title)
    end
  end

  describe "filtering lists", js: true do
    let(:user_with_completed_lists) { FactoryBot.create(:user_with_completed_lists) }
    let(:user_with_lists) { FactoryBot.create(:user_with_lists) }
    it "hides newly completed list" do
      login_as(user_with_lists, :scope => :user)
      visit root_path
      list = user_with_lists.lists.first
      check("complete-#{list.id}")
      click_button("Hide Completed Lists")
      within(".table-responsive tbody") do
        expect(page).to_not have_content(list.title)
      end
    end
    it "only shows incomplete lists" do
      login_as(user_with_completed_lists, :scope => :user)
      visit root_path
      lists = user_with_completed_lists.lists
      lists.each do |list|
        expect(find("#list__title-#{list.id}").value).to eq(list.title)
      end
      click_button("Hide Completed Lists")
      within(".table-responsive tbody") do
        lists.each do |list|
          expect(page).to_not have_content(list.title)
        end
      end
    end
  end

end
