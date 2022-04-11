require 'rails_helper'

RSpec.describe List, type: :model do

  describe "creation" do
    let(:list) { FactoryBot.create(:list) }
    it "can be created" do
      expect(list).to be_valid
    end
  end

  describe "validations" do
    let(:list) { FactoryBot.build(:list) }
    it "should have a title" do
      list.title = nil
      expect(list).to_not be_valid
    end
    it "should have a user" do
      list.user = nil
      expect(list).to_not be_valid
    end    
  end

  describe "default values" do
    let(:list) { FactoryBot.build(:list) }
    it "should have complete set to false" do
      expect(list.complete).to eq(false)
    end
  end

  describe "order scope" do
    let!(:old_list) { FactoryBot.create(:list, created_at: Time.now - 1.day) }
    let!(:future_list) { FactoryBot.create(:list, created_at: Time.now + 1.day) }
    it "short sort lists in descending order" do
      expect(List.first).to eq(future_list)
    end
  end

end
