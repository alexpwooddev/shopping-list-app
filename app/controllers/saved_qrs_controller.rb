class SavedQrsController < ApplicationController
  before_action :set_saved_qr
  before_action :correct_user, only: [:show, :edit, :update, :destroy]

  def index
    @user_saved_qrs = current_user.saved_qrs
  end

  def show
    return not_found unless @saved_qr

    @saved_qr
  end

  def edit
    @saved_qr ? @saved_qr : redirect_to(saved_qrs_path)
  end

  def update
    @saved_qr.update_attribute(:quantity, params[:quantity])
    flash[:success] = "QR updated successfully"
    redirect_to saved_qrs_path
  end

  def destroy
    @saved_qr.destroy
    flash[:success] = "QR deleted"
    redirect_to saved_qrs_path
  end


  private

  def set_saved_qr
    @saved_qr = SavedQr.find_by(id: params[:id])
  end

  def authorized?
    @saved_qr? @saved_qr.user == current_user : false
  end

  def correct_user
    return true if authorized?

    flash[:warning] = "You can't access that page or it doesn't exist"
    redirect_to saved_qrs_path
  end

end
