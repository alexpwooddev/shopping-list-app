require 'rails_helper'

RSpec.describe SavedQr, type: :model do
  describe "creation" do
    let(:saved_qr) { FactoryBot.create(:saved_qr) }
    it "can be created" do
      expect(saved_qr).to be_valid
    end
  end

  describe "validations" do
    let(:saved_qr) { FactoryBot.build(:saved_qr) }
    it "should have a quantity" do
      saved_qr.quantity = nil
      expect(saved_qr).to_not be_valid
    end
    it "should have a user" do
      saved_qr.user = nil
      expect(saved_qr).to_not be_valid
    end
    it "should have a product" do
      saved_qr.product = nil
      expect(saved_qr).to_not be_valid
    end
  end
end
