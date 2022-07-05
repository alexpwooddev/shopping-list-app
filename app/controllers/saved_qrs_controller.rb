class SavedQrsController < ApplicationController
  before_action :set_saved_qr

  def index
    @user_saved_qrs = current_user.saved_qrs
  end

  def show
    unless @saved_qr
      not_found
    end

    unless authorized?
      handle_unauthorized
    end

    @saved_qr
  end

  def edit
    @saved_qr ? @saved_qr : redirect_to(saved_qrs_path)
  end

  def update
    unless authorized?
      handle_unauthorized
    end

    @saved_qr.update_attribute(:quantity, params[:quantity])
    flash[:success] = "QR updated successfully"
    redirect_to index
  end

  def destroy
  end


  private

  def set_saved_qr
    @saved_qr = SavedQr.find_by(id: params[:id])
  end

  def authorized?
    @saved_qr.user == current_user
  end

  def handle_unauthorized
    puts "not authorized!"
    render_401
  end

  def render_401
    render :template => "errors/unauthorized", :status => :unauthorized
  end
end
