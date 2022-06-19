require 'rails_helper'

RSpec.describe "SavedQrs", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/saved_qrs/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/saved_qrs/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/saved_qrs/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
