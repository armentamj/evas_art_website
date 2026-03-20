class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    # This generates the secure token based on the logic in the User model
    @token = user.generate_token_for(:password_reset)

    mail subject: "Reset your password", to: user.email_address
  end
end
