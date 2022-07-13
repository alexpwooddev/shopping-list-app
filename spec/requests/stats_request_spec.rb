require 'rails_helper'

RSpec.describe "Stats", type: :request do

  describe "GET /index" do
    let!(:user) { FactoryBot.create(:user_with_saved_qrs) }

    context "when not authenticated" do
      it "redirects to users/sign in" do
        get "/stats"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns the index page with at least one item" do
        sign_in(user, :scope => :user)
        get "/stats"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).to include("<li")
      end
    end


  end

end
