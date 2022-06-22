class SavedQrsController < ApplicationController
  def index
    # returns all savedQrs for current user
    @user_saved_Qrs = current_user.saved_qrs
    @user_saved_Qrs.each do |qr|
      # product name
      product = Product.find_by(id: qr.product_id);
      puts product.name
      puts "prod_id: #{qr.product_id}"
      puts "quantity: #{qr.quantity}"
    end
  end

  def show
    # returns a savedQr for current user

  end

  def edit
  end

  def update
  end

  def destroy
  end
end
