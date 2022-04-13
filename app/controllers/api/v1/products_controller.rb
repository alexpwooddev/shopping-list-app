class Api::V1::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show]

  def index
    @products = Product.all
  end

  def show
      respond_to do |format|
        format.json { render :show }
      end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

end
