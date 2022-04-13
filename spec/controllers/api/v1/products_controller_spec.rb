require 'rails_helper'

RSpec.describe Api::V1::ProductsController do
  render_views
  describe "index" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:products) { FactoryBot.create_list(:product, 5) }
    context "when authenticated" do
      it "displays all products" do
        sign_in user
        get :index, format: :json
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(JSON.parse(products.to_json))
      end
    end
    context "when not authenticated" do
      it "returns unauthorized" do
        get :index, format: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe "show" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:product) { FactoryBot.create(:product) }
    context "when authenticated" do
      it "returns a product" do
        sign_in user
        get :show, format: :json, params: { id: product.id }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(JSON.parse(product.to_json))
      end
    end
    context "when not authenticated" do
      it "returns unauthorized" do
        get :show, format: :json, params: { id: product.id }
        expect(response.status).to eq(401)
      end
    end
  end
end