class SavedQrsController < ApplicationController
  def index
    @user_saved_qrs = current_user.saved_qrs
  end

  def show
    saved_qr_id = params[:id]
    @saved_qr = SavedQr.find_by(id: saved_qr_id)
    @saved_qr ? @saved_qr : redirect_to(saved_qrs_path)
    # TO DO - add user notification of redirect
  end

  def edit
    saved_qr_id = params[:id]
    @saved_qr = SavedQr.find_by(id: saved_qr_id)
    @saved_qr ? @saved_qr : redirect_to(saved_qrs_path)
  end

  def update
  end

  def destroy
  end
end
