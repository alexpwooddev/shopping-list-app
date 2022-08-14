require 'rails_helper'

RSpec.describe "PublishedLists", type: :request do

  describe "GET /index" do
    let!(:user) { FactoryBot.create(:user)}
    let!(:another_user) { FactoryBot.create(:user)}
    let!(:favourited_list) { FactoryBot.create(:favourited_list)}

    context "when not authenticated" do
      it "redirects to users/sign in" do
        get "/favourited_lists"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns index with at least one item" do
        favourited_list.user = another_user

        sign_in(user, :scope => :user)
        get "/favourited_lists"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).to include("<li")
      end
    end

  end

end