require 'rails_helper'

RSpec.feature "HomepageFlows", type: :feature do
  describe "homepage" do
    let!(:user) { FactoryBot.create(:user) }
=begin
    context "when the user is anonymous" do
      it "renders a page with a link to the sign up form" do
        visit authenticated_root_path
        expect(page).to have_content("Please Sign In to continue")
        expect(page).to have_current_path(root_path)
      end
    end
=end
    context "when the user is authenticated" do
      it "renders a page with their Lists" do
        login_as(user, :scope => :user)
        visit authenticated_root_path
        expect(page).to have_content("My Lists")
        expect(page).to have_current_path(authenticated_root_path)
      end
    end    
  end
end
