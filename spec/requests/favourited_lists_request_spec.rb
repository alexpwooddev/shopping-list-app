require 'rails_helper'

RSpec.describe "PublishedLists", type: :request do

  describe "GET /index" do
    # TODO
    # need a user with favourited_list FROM another user
    # let!(:user) { FactoryBot.create(:user_with_lists)}

    context "when not authenticated" do
      it "redirects to users/sign in" do
        get "/favourited_lists"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns index with at least one item" do
        get "/favourited_lists"
        # TODO
      end
    end

  end

end