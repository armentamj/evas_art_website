class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Ensure the email is present, unique, and looks like an email
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # This is for the reset links
  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt.last(10)
  end

  # Basic validation so users don't pick 1-character passwords
  validates :password, length: { minimum: 8 }, allow_nil: true
end
