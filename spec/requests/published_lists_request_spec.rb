require 'rails_helper'

RSpec.describe "PublishedLists", type: :request do

  describe "GET /index" do
    context "when not authenticated" do
      it "returns http success" do
        get "/published_lists"
        expect(response).to have_http_status(:success)
      end

      # TODO
      # it "doesn't allow rating" do
      # end
    end

    context "when authenticated" do
      it "returns http success" do
        get "/published_lists"
        expect(response).to have_http_status(:success)
      end

      it "allows rating" do

      end
    end


  end

end
