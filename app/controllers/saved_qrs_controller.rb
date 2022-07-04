class SavedQrsController < ApplicationController
  # not sure I actually need this here at all? don't my routes set this up?
  # before_action :authenticate_user!
  before_action :set_saved_qr

  def index
    @user_saved_qrs = current_user.saved_qrs
  end

  def show
    if authorized?
      if @saved_qr
        @saved_qr
      else
        redirect_to(saved_qrs_path)
        flash[:alert] = "no such QR exists"
      end
    else
      handle_unauthorized
    end
  end

  def edit
    @saved_qr ? @saved_qr : redirect_to(saved_qrs_path)
  end

  def update
    if authorized?
      @saved_qr.update_attribute(:quantity, params[:quantity])
      flash[:success] = "QR updated successfully"
      redirect_to index
    else
      handle_unauthorized
    end
  end

  def destroy
  end

  private

  def set_saved_qr
    @saved_qr = SavedQr.find_by(id: params[:id])
  end

  def authorized?
    @saved_qr&.user == current_user
  end

  def handle_unauthorized
    unless authorized?
      render :file => "public/401.html", :status => :unauthorized
    end
  end
end
