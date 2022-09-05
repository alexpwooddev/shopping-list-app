require 'rails_helper'

RSpec.describe "SavedQrs", type: :request do

  describe "GET /index" do
    let!(:user) { FactoryBot.create(:user_with_saved_qrs) }

    context "when not authenticated" do
      it "redirects to users/sign_in" do
        get "/saved_qrs"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns the index page with at least one item" do
        sign_in(user, :scope => :user)
        get "/saved_qrs"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).to include("<li")
      end
    end
  end

  describe "GET /show" do
    let!(:user) { FactoryBot.create(:user_with_saved_qrs) }
    let!(:another_user_with_saved_qrs) { FactoryBot.create(:user_with_saved_qrs) }

    context "when not authenticated" do
      it "redirects to users/sign_in" do
        get "/saved_qrs"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns the show page and a user's saved_qr" do
        sign_in(user, :scope => :user)
        user_saved_qr = user.saved_qrs.first
        get "/saved_qrs/#{user_saved_qr.id.to_s}"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
        expect(response.body).to include("<p>")
      end

      it "redirects to index for wrong saved_qr" do
        sign_in(user, :scope => :user)
        user_saved_qr = user.saved_qrs.first
        get "/saved_qrs/#{(user_saved_qr.id + 1000)}"
        expect(response).to have_http_status(:redirect)
        assert_redirected_to saved_qrs_path
      end

      it "redirects to index if a user tries to view another user's saved_qr" do
        sign_in(user, :scope => :user)
        another_user_saved_qr = another_user_with_saved_qrs.saved_qrs.first
        get "/saved_qrs/#{another_user_saved_qr.id.to_s}"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to saved_qrs_path
      end
    end
  end

  describe "GET /edit" do
    let!(:user) { FactoryBot.create(:user_with_saved_qrs) }
    let!(:saved_qr) { FactoryBot.create(:saved_qr) }

    context "when not authenticated" do
      it "redirects to users/sign_in" do
        user_saved_qr = user.saved_qrs.first
        get "/saved_qrs/#{user_saved_qr.id.to_s}/edit"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "returns the edit page with a form" do
        sign_in(user, :scope => :user)
        user_saved_qr = user.saved_qrs.first
        get "/saved_qrs/#{user_saved_qr.id.to_s}/edit"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
        expect(response.body).to include("<form")
      end
    end
  end

  describe "PATCH /update" do
    let!(:user_with_saved_qrs) { FactoryBot.create(:user_with_saved_qrs) }
    let!(:another_user_with_saved_qrs) { FactoryBot.create(:user_with_saved_qrs) }

    context "when not authenticated" do
      it "redirects to users/sign_in" do
        saved_qr = user_with_saved_qrs.saved_qrs.first
        patch "/saved_qrs/#{saved_qr.id.to_s}"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "updates the user's saved_qr" do
        sign_in(user_with_saved_qrs, :scope => :user)
        saved_qr = user_with_saved_qrs.saved_qrs.first
        new_quantity = saved_qr.quantity + 1
        patch "/saved_qrs/#{saved_qr.id.to_s}", params: { quantity: new_quantity }
        saved_qr.reload
        expect(saved_qr.quantity).to eq(new_quantity)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(saved_qrs_path)
      end

      it "doesn't allow updates of another user's saved_qr" do
        sign_in(user_with_saved_qrs, :scope => :user)
        another_user_saved_qr = another_user_with_saved_qrs.saved_qrs.first
        new_quantity = another_user_saved_qr.quantity + 1
        patch "/saved_qrs/#{another_user_saved_qr.id.to_s}", params: { quantity: new_quantity }
        another_user_saved_qr.reload
        expect(another_user_saved_qr.quantity).not_to eq(new_quantity)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(saved_qrs_path)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:user) { FactoryBot.create(:user_with_saved_qrs) }
    let!(:another_user_with_saved_qrs) { FactoryBot.create(:user_with_saved_qrs) }

    context "when not authenticated" do
      it "redirects to index" do
        saved_qr = user.saved_qrs.first
        delete "/saved_qrs/#{saved_qr.id.to_s}"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      it "does nothing if not authorized" do
        sign_in(user, :scope => :user)
        another_users_saved_qr = another_user_with_saved_qrs.saved_qrs.first
        assert_no_difference "SavedQr.count" do
          delete "/saved_qrs/#{another_users_saved_qr.id.to_s}"
        end
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(saved_qrs_path)
      end

      it "deletes the user's saved_qr" do
        sign_in(user, :scope => :user)
        saved_qr = user.saved_qrs.first
        assert_difference "SavedQr.count", -1 do
          delete "/saved_qrs/#{saved_qr.id.to_s}"
        end
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(saved_qrs_path)
      end
    end
  end

end
