require 'rails_helper'

RSpec.describe Api::V1::ListItemsController do
  render_views
  describe "index" do
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    context "when authenticated" do
      it "displays the given list's list items" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        get :index, format: :json, params: { list_id: list.id }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(JSON.parse(list.list_items.to_json))
      end
    end
    context "when not authenticated" do
      it "returns unauthorized" do
        list = user_with_lists_with_items.lists.first
        get :index, format: :json, params: { list_id: list.id }
        expect(response.status).to eq(401)
      end
    end
  end

  describe "show" do
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    let!(:another_user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    context "when authenticated" do
      it "returns a list item" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        list_item = list.list_items.first
        get :show, format: :json, params: { id: list_item.id, list_id: list.id }
        expect(response.status).to eq(200)
        #expect(JSON.parse(response.body)).to eq(JSON.parse(list.to_json))
      end
      it "does not allow a user to view other's list items" do
        sign_in user_with_lists_with_items
        another_users_list = another_user_with_lists_with_items.lists.first
        another_users_list_item = another_users_list.list_items.first
        get :show, format: :json, params: { id: another_users_list_item.id, list_id: another_users_list.id }
        expect(response.status).to eq(401)
      end
    end
    context "when not authenticated" do
      it "returns unauthorized" do
        list = user_with_lists_with_items.lists.first
        list_item = list.list_items.first
        get :show, format: :json, params: { id: list_item.id, list_id: list.id }
        expect(response.status).to eq(401)
      end
    end
  end

  describe "create" do
    let!(:product) { FactoryBot.create(:product) }
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    let!(:another_user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    context "when authenticated" do
      it "returns a list item" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        new_list_item = { quantity: 1, list_id: 1, product_id: product.id }
        post :create, format: :json, params: { list_item: new_list_item, list_id: list.id }
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)["quantity"]).to eq(new_list_item[:quantity])
      end
      it "creates a list item" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        new_list_item = { quantity: 1, list_id: 1, product_id: product.id }
        expect { post :create, format: :json, params: { list_item: new_list_item, list_id: list.id } }.to change { ListItem.count }.by(1)
      end
      it "returns a message if invalid" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        invalid_new_list_item = {quantity: "", list_id: 1, product_id: product.id }
        expect { post :create, format: :json, params: { list_item: invalid_new_list_item, list_id: list.id } }.to_not change{ ListItem.count }
        expect(response.status).to eq(422)
      end
      it "does not allow a user to create other's list items" do
        sign_in user_with_lists_with_items
        another_users_list = another_user_with_lists_with_items.lists.first
        new_list_item = { quantity: 1, list_id: 1, product_id: product.id }
        post :create, format: :json, params: { list_item: new_list_item, list_id: another_users_list.id }
        expect(response.status).to eq(401)
      end
    end
    context "when not authenticated" do
      it "returns unauthorized" do
        list_of_not_logged_in_user = user_with_lists_with_items.lists.first
        new_list_item = { quantity: 1, list_id: 1, product_id: product.id }
        post :create, format: :json, params: { list_item: new_list_item, list_id: list_of_not_logged_in_user.id }
        expect(response.status).to eq(401)
      end
    end
  end

  describe "update" do
    let!(:product) { FactoryBot.create(:product) }
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    let!(:another_user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    context "when authenticated" do
      it "returns a list item" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        exiting_list_item = list.list_items.first
        new_list_item = { quantity: 2, list_id: list.id, product_id: product.id }
        put :update, format: :json, params: { list_item: new_list_item, list_id: list.id, id: exiting_list_item.id }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["quantity"]).to eq(new_list_item[:quantity])
      end
      it "does not allow a user to update other's list items" do
        sign_in user_with_lists_with_items
        another_users_list = another_user_with_lists_with_items.lists.first
        another_users_existing_item = another_users_list.list_items.first
        new_list_item = { quantity: 2, list_id: another_users_list.id, product_id: product.id }
        put :update, format: :json, params: { list_item: new_list_item, list_id: another_users_list.id, id: another_users_existing_item.id }
        expect(response.status).to eq(401)
      end
      it "returns a message if invalid" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        exiting_list_item = list.list_items.first
        new_list_item = { quantity: "", list_id: list.id, product_id: product.id }
        put :update, format: :json, params: { list_item: new_list_item, list_id: list.id, id: exiting_list_item.id }
        expect(response.status).to eq(422)
      end
    end
    context "when not authenticated" do
      it "returns unauthorized" do
        list_of_not_logged_in_user = user_with_lists_with_items.lists.first
        exiting_list_item = list_of_not_logged_in_user.list_items.first
        new_list_item = { quantity: 1, list_id: 1, product_id: product.id }
        put :create, format: :json, params: { list_item: new_list_item, list_id: exiting_list_item.id }
        expect(response.status).to eq(401)
      end
    end
  end

  describe "destroy" do
    let!(:product) { FactoryBot.create(:product) }
    let!(:user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    let!(:another_user_with_lists_with_items) { FactoryBot.create(:user_with_lists_with_items) }
    context "when authenticated" do
      it "returns no content" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        destroyed_list_item = list.list_items.first
        delete :destroy, format: :json, params: { list_id: list.id, id: destroyed_list_item.id }
        expect(response.status).to eq(204)
      end
      it "destroys a list" do
        sign_in user_with_lists_with_items
        list = user_with_lists_with_items.lists.first
        destroyed_list_item = list.list_items.first
        expect{ delete :destroy, format: :json, params: { list_id: list.id, id: destroyed_list_item.id } }.to change { ListItem.count }.by(-1)
      end
      it "does not allow a user to destroy other's list items" do
        sign_in user_with_lists_with_items
        another_users_list = another_user_with_lists_with_items.lists.first
        destroyed_list_item = another_users_list.list_items.first
        expect{ delete :destroy, format: :json, params: { list_id: another_users_list.id, id: destroyed_list_item.id } }.to_not change{ ListItem.count }
      end
    end
    context "when not authenticated" do
      it "returns unauthorized" do
        list = user_with_lists_with_items.lists.first
        destroyed_list_item = list.list_items.first
        delete :destroy, format: :json, params: { list_id: list.id, id: destroyed_list_item.id }
        expect(response.status).to eq(401)
      end
    end
  end

end
