class Api::V1::ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [:show, :update, :destroy]

  def index
    @lists = current_user.lists.all
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
    @list = current_user.lists.build(list_params)
    if authorized?
      respond_to do |format|
        if @list.save
          format.json { render :show, status: :created, location: api_v1_list_path(@list) }
        else
          format.json { render json: @list.errors, status: :unprocessable_entity }
        end
      end
    else
      handle_unauthorized
    end
  end

  def update
    if authorized?
      respond_to do |format|
        if @list.update(list_params)
          format.json { render :show, status: :ok, location: api_v1_list_path(@list) }
        else
          format.json { render json: @list.errors, status: :unprocessable_entity }
        end
      end
    else
      handle_unauthorized
    end
  end

  def destroy
    if authorized?
      @list.destroy
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      handle_unauthorized
    end
  end

  private

  def set_list
    @list = List.find(params[:id])
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

  def list_params
    params.require(:list).permit(:title, :complete, :published)
  end
end
