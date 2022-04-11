require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  describe "logging in" do
    let!(:user) { FactoryBot.create(:user) }
    it "logs the user in and redirects to their lists" do
      visit root_path
      click_link "Login"
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      expect(page).to have_content("My Lists")
      expect(page).to have_current_path(authenticated_root_path)
    end
  end
end
