require 'rails_helper'

RSpec.describe "SavedQrs", type: :request do
  describe "GET /show" do
    let!(:user) { FactoryBot.create(:user) }
    context "when the user is anonymous" do
      it "returns http redirect" do
        get "/saved_qrs/show"
        expect(response).to have_http_status(:redirect)
      end
    end
    context "when the user is authenticated" do
      it "returns http success" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/show"
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /edit" do
    let!(:user) { FactoryBot.create(:user) }
    context "when the user is anonymous" do
      it "returns http redirect" do
        get "/saved_qrs/edit"
        expect(response).to have_http_status(:redirect)
      end
    end
    context "when the user is authenticated" do
      it "returns http success" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/edit"
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /destroy" do
    let!(:user) { FactoryBot.create(:user) }
    context "when the user is anonymous" do
      it "returns http redirect" do
        get "/saved_qrs/destroy"
        expect(response).to have_http_status(:redirect)
      end
    end
    context "when the user is authenticated" do
      it "returns http success" do
        sign_in(user, :scope => :user)
        get "/saved_qrs/destroy"
        expect(response).to have_http_status(:success)
      end
    end
  end

end
