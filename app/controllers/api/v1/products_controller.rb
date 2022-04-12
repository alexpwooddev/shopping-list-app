class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show]

  def index
    @products = Product.all
  end

  def show
    if authorized?
      respond_to do |format|
        format.json { render :show }
      end
    else
      handle_unauthorized
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

end
