require 'rails_helper'

RSpec.describe "SavedQrs", type: :request do
  describe "GET /index" do
    let!(:user) { FactoryBot.create(:user) }
    context "when not authenticated" do
      it "returns http redirect and redirects to users/sign_in" do
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
    let!(:user) { FactoryBot.create(:user) }
    let!(:saved_qr) { FactoryBot.create(:saved_qr) }
    context "when not authenticated" do
      it "returns http redirect and redirects to users/sign_in" do
        get "/saved_qrs"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when authenticated" do
      it "returns the show page and its saved_qr item" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/#{saved_qr.id.to_s}"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
        expect(response.body).to include("<p>")
      end
      it "redirects to saved_qrs if saved_qr doesn't exist for this user" do
        sign_in(user, :scope => :user)
        get"/saved_qrs/#{(saved_qr.id + 1000).to_s}"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(saved_qrs_path)
      end
    end
  end

  describe "GET /edit" do
  let!(:user) { FactoryBot.create(:user) }
  let!(:saved_qr) { FactoryBot.create(:saved_qr) }
    context "when not authenticated" do
      it "returns http redirect and redirects to users/sign_in" do
        get "/saved_qrs/#{saved_qr.id.to_s}/edit"
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context "when authenticated" do
      it "returns the edit page with a form" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/#{saved_qr.id.to_s}/edit"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
        expect(response.body).to include("<form")
      end
    end
  end

  # describe "PATCH /update" do # TO DO - need ID here
  #   let!(:user) { FactoryBot.create(:user) }
  #   context "when not authenticated" do
  #     it "returns http redirect" do
  #       # get "/saved_qrs/update" TO DO - need ID here
  #     end
  #   end
  # end

  # describe "GET /destroy" do
  #   let!(:user) { FactoryBot.create(:user) }
  #   context "when not authenticated" do
  #     it "returns http redirect" do
  #       get "/saved_qrs/destroy"
  #       expect(response).to have_http_status(:redirect)
  #     end
  #   end
  #   context "when authenticated" do
  #     it "returns http success" do
  #       sign_in(user, :scope => :user)
  #       get "/saved_qrs/destroy"
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  # end

end
