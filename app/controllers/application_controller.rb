class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :set_locale

  private

  def set_locale
    # 1. Priority: URL param -> 2. Priority: Permanent Cookie -> 3. Priority: App Default
    locale = params[:locale] || cookies[:locale] || I18n.default_locale

    # Only update the permanent cookie if the locale is valid
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      cookies.permanent[:locale] = params[:locale]
    end

    I18n.locale = locale
  end

  # Ensures the locale is automatically added to all links (e.g. link_to)
  def default_url_options
    { locale: I18n.locale }
  end
end
