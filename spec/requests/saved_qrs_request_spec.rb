require 'rails_helper'

RSpec.describe "SavedQrs", type: :request do
  describe "GET /index" do
    let!(:user) { FactoryBot.create(:user) }
    context "when not authenticated" do
      it "returns http redirect" do
        get "/saved_qrs/show"
        expect(response).to have_http_status(:redirect)
      end
    end
    context "when authenticated" do
      it "returns http success" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/show"
        expect(response).to have_http_status(:success)
      end
      it "returns saved_qrs or a 'no qrs' message"
    end
  end

  describe "GET /show" do
    let!(:user) { FactoryBot.create(:user) }
    context "when not authenticated" do
      it "returns http redirect" do
        get "/saved_qrs/show"
        expect(response).to have_http_status(:redirect)
      end
    end
    context "when authenticated" do
      it "returns http success" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/show"
        expect(response).to have_http_status(:success)
      end
      it "returns a saved_qr or a 'no qr' message"
    end
  end

  describe "GET /edit" do # TO DO - need ID here
    let!(:user) { FactoryBot.create(:user) }
    context "when not authenticated" do
      it "returns http redirect" do
        get "/saved_qrs/edit"
        expect(response).to have_http_status(:redirect)
      end
    end
    context "when authenticated" do
      it "returns http success" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/edit"
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH /update" do # TO DO - need ID here
    let!(:user) { FactoryBot.create(:user) }
    context "when not authenticated" do
      it "returns http redirect" do
        # get "/saved_qrs/update" TO DO - need ID here
      end
    end
  end

  describe "GET /destroy" do
    let!(:user) { FactoryBot.create(:user) }
    context "when not authenticated" do
      it "returns http redirect" do
        get "/saved_qrs/destroy"
        expect(response).to have_http_status(:redirect)
      end
    end
    context "when authenticated" do
      it "returns http success" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/destroy"
        expect(response).to have_http_status(:success)
      end
    end
  end

end
