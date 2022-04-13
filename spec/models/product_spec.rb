require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "creation" do
    let(:product) { FactoryBot.create(:product) }
    it "can be created" do
      expect(product).to be_valid
    end
  end

  describe "validations" do
    let(:product) { FactoryBot.build(:product) }
    it "should have a name" do
      product.name = nil
      expect(product).to_not be_valid
    end
  end
end
