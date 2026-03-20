class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  def edit
    @user = User.find_by_token_for(:password_reset, params[:token])

    if @user.nil?
      redirect_to new_password_path, alert: "Invalid or expired password reset link."
    end
  end

  def update
    @user = User.find_by_token_for(:password_reset, params[:token])

    if @user&.update(params.expect(user: [ :password, :password_confirmation ]))
      redirect_to new_session_path, notice: "Password has been reset successfully. Please log in."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
