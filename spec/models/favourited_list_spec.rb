require 'rails_helper'

RSpec.describe FavouritedList, type: :model do

  describe "creation" do
    let(:favourited_list) { FactoryBot.create(:favourited_list)}
    it "can be created" do
      expect(favourited_list).to be_valid
    end
  end

  describe "order scope" do
    let!(:old_list) { FactoryBot.create(:favourited_list, created_at: Time.now - 1.day) }
    let!(:future_list) { FactoryBot.create(:favourited_list, created_at: Time.now + 1.day) }
    it "short sort favourited lists in descending order" do
      expect(FavouritedList.first).to eq(future_list)
    end
  end
end