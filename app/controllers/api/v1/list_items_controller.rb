class Api::V1::ListItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [:index, :show, :create, :update, :destroy]
  before_action :set_list_item, only: [:show, :update, :destroy]

  def index
    if authorized?
      list_id = params[:list_id]
      @list_items = ListItem.where(list_id: list_id)
    else
      handle_unauthorized
    end
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

  def create
    @list_item = @list.list_items.build(list_item_params)
    if authorized?
      respond_to do |format|
        if @list_item.save
          puts "saved and returning items as json"
          format.json { render :show, status: :created, location: api_v1_list_list_items_path(@list_item) }
        else
          puts "attempting update instead..."
          existing_item = ListItem.find_by(product_id: @list_item.product_id)
          new_quantity = existing_item.quantity + @list_item.quantity
          if ListItem.update(existing_item.id, :quantity => new_quantity)
            puts "updated!"
            format.json { render :show, status: :ok, location: api_v1_list_list_items_path(existing_item) }
          else
            format.json { render json: @list_item.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      handle_unauthorized
    end
  end

=begin
  def update
    if authorized?
      respond_to do |format|
        if @list_item.update(list_item_params)
          format.json { render :show, status: :ok, location: api_v1_list_list_item_path(@list_item) }
        else
          format.json { render json: @list_item.errors, status: :unprocessable_entity }
        end
      end
    else
      handle_unauthorized
    end
  end
=end

  def destroy
    if authorized?
      @list_item.destroy
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      handle_unauthorized
    end
  end

  private

  def set_list
    @list = List.find(params[:list_id])
    puts @list
  end

  def set_list_item
    @list_item = ListItem.find(params[:id])
  end

  def authorized?
    @list.user == current_user
  end

  def handle_unauthorized
    unless authorized?
      respond_to do |format|
        format.json { render :unauthorized, status: 401 }
      end
    end
  end

  def list_item_params
    params.require(:list_item).permit(:quantity, :product_id)
  end

end
