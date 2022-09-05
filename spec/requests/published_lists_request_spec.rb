require 'rails_helper'

RSpec.describe "PublishedLists", type: :request do

  describe "GET /index" do
    context "when authenticated or not" do
      it "returns index with at least one item" do
        get "/published_lists"
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
        expect(response.body).to include("<ul")
      end
    end

    context "when not authenticated" do
      # TODO
      it "doesn't allow rating" do
      end
    end

    context "when authenticated" do
      # TODO
      it "allows rating" do
      end
    end

  end
end
