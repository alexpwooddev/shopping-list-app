require 'rails_helper'

RSpec.describe "FavouritedLists", type: :request do

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
        sign_in(user, :scope => :user)
        get "/favourited_lists"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).to include("<li")
      end
    end

  end

  describe "POST /create" do
    let!(:user) { FactoryBot.create(:user_with_favourited_list)}
    let!(:list) { FactoryBot.create(:list_with_items)}
    let!(:another_user) { FactoryBot.create(:user_with_lists_with_items)}

    context "when not authenticated" do
      it "redirects to users/sign_in" do
        post "/favourited_lists", params: { user: :user, list: :list }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "creates a new favourited list" do
        sign_in(user, :scope => :user)
        list = another_user.lists.first

        post "/favourited_lists", params: { id: list.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(favourited_lists_path)
      end

      it "redirects to published_lists if attempts to favourite twice" do
        sign_in(user, :scope => :user)
        list_id = user.favourited_lists.first.list_id

        post "/favourited_lists", params: { id: list_id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(published_lists_path)
      end
    end

  end

  describe "DELETE /destroy" do
    let!(:user) { FactoryBot.create(:user)}
    let!(:favourited_list) { FactoryBot.create(:favourited_list)}

    context "when not authenticated" do
      # TODO
      it "redirects to users/sign_in" do
        delete "/favourited_lists/#{favourited_list.id}"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      # TODO
    end
  end

end