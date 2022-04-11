require 'rails_helper'

RSpec.describe Api::V1::ListsController do
    render_views
    describe "index" do
        let!(:user_with_lists) { FactoryBot.create(:user_with_lists) }
        context "when authenticated" do
            it "displays the current user's lists" do
                sign_in user_with_lists
                get :index, format: :json
                expect(response.status).to eq(200)
                expect(JSON.parse(response.body)).to eq(JSON.parse(user_with_lists.lists.to_json))
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
        let!(:user_with_lists) { FactoryBot.create(:user_with_lists) }
        let!(:another_user_with_lists) { FactoryBot.create(:user_with_lists) }
        context "when authenticated" do
            it "returns a list" do
                list = user_with_lists.lists.first
                sign_in user_with_lists
                get :show, format: :json, params: { id: list.id }
                expect(response.status).to eq(200)
                expect(JSON.parse(response.body)).to eq(JSON.parse(list.to_json))
            end
            it "does not allow a user to view other's lists" do
                another_users_list = another_user_with_lists.lists.first
                sign_in user_with_lists
                get :show, format: :json, params: { id: another_users_list.id }
                expect(response.status).to eq(401)
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                list = user_with_lists.lists.first
                get :show, format: :json, params: { id: list.id }
                expect(response.status).to eq(401)
            end
        end
    end

    describe "create" do
        let!(:user_with_lists) { FactoryBot.create(:user_with_lists) }
        let!(:another_user_with_lists) { FactoryBot.create(:user_with_lists) }
        context "when authenticated" do
            it "returns a list" do
                sign_in user_with_lists
                new_list = { title: "a new list", user: user_with_lists }
                post :create, format: :json, params: { list: new_list }
                expect(response.status).to eq(201)
                expect(JSON.parse(response.body)["title"]).to eq(new_list[:title])
            end
            it "creates a list" do
                sign_in user_with_lists
                new_list = { title: "a new list", user: user_with_lists }
                expect { post :create, format: :json, params: { list: new_list } }.to change { List.count }.by(1)
            end
            it "returns a message if invalid" do
                sign_in user_with_lists
                invalid_new_list = { title: "", user: user_with_lists }
                expect { post :create, format: :json, params: { list: invalid_new_list } }.to_not change{ List.count }
                expect(response.status).to eq(422)
            end
            it "does not allow a user to create other's lists" do
                sign_in user_with_lists
                new_list = { title: "a new list create by the wrong accout", user: another_user_with_lists }
                post :create, format: :json, params: { list: new_list }
                expect(JSON.parse(response.body)["user_id"]).to eq(user_with_lists.id)
                expect(JSON.parse(response.body)["user_id"]).to_not eq(another_user_with_lists.id)
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                new_list = { title: "a new list", user: user_with_lists }
                post :create, format: :json, params: { list: new_list }
                expect(response.status).to eq(401)
            end
        end
    end

    describe "update" do
        let!(:user_with_lists) { FactoryBot.create(:user_with_lists) }
        let!(:another_user_with_lists) { FactoryBot.create(:user_with_lists) }
        context "when authenticated" do
            it "returns a list" do
                sign_in user_with_lists
                updated_list = user_with_lists.lists.first
                updated_list_title = "updated"
                put :update, format: :json, params: { list: { title: updated_list_title  }, id: updated_list.id }
                expect(response.status).to eq(200)
                expect(JSON.parse(response.body)["title"]).to eq(updated_list_title)
            end
            it "does not allow a user to update other's lists" do
                sign_in user_with_lists
                another_users_updated_list = another_user_with_lists.lists.first
                updated_list_title = "updated"
                put :update, format: :json, params: { list: { title: updated_list_title  }, id: another_users_updated_list.id }
                expect(response.status).to eq(401)
            end
            it "returns a message if invalid" do
                sign_in user_with_lists
                updated_list = user_with_lists.lists.first
                updated_list_title = ""
                put :update, format: :json, params: { list: { title: updated_list_title  }, id: updated_list.id }
                expect(response.status).to eq(422)
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                updated_list = user_with_lists.lists.first
                updated_list_title = "updated"
                put :update, format: :json, params: { list: { title: updated_list_title  }, id: updated_list.id }
                expect(response.status).to eq(401)
            end
        end
    end

    describe "destroy" do
        let!(:user_with_lists) { FactoryBot.create(:user_with_lists) }
        let!(:another_user_with_lists) { FactoryBot.create(:user_with_lists) }
        context "when authenticated" do
            it "returns no content" do
                sign_in user_with_lists
                destroyed_list = user_with_lists.lists.first
                delete :destroy, format: :json, params: { id: destroyed_list.id }
                expect(response.status).to eq(204)
            end
            it "destroys a list" do
                sign_in user_with_lists
                destroyed_list = user_with_lists.lists.first
                expect{ delete :destroy, format: :json, params: { id: destroyed_list.id } }.to change { List.count }.by(-1)
            end
            it "does not allow a user to destroy other's lists" do
                sign_in user_with_lists
                another_users_destroyed_list = another_user_with_lists.lists.first
                expect{ delete :destroy, format: :json, params: { id: another_users_destroyed_list.id } }.to_not change{ List.count }
            end
        end
        context "when not authenticated" do
            it "returns unauthorized" do
                destroyed_list = user_with_lists.lists.first
                delete :destroy, format: :json, params: { id: destroyed_list.id }
                expect(response.status).to eq(401)
            end
        end          
    end

end
