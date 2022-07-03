class SavedQrsController < ApplicationController
  # not sure I actually need this here at all? don't my routes set this up?
  # before_action :authenticate_user!
  before_action :set_saved_qr

  def index
    @user_saved_qrs = current_user.saved_qrs
  end

  def show
    @saved_qr ? @saved_qr : redirect_to(saved_qrs_path)
    # TO DO - add user notification of redirect
  end

  def edit
    @saved_qr ? @saved_qr : redirect_to(saved_qrs_path)
  end

  def update
    # should Devise and my routing be handling auth before anything even gets here?
    # i.e. i'm just handling success/failure based on request payload?
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
    @saved_qr = SavedQr.find(params[:id])
  end

  def authorized
    @saved_qr.user == current_user
  end
end
