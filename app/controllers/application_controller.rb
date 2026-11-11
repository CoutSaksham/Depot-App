class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authorize
  # ...

  def default_url_options
    { locale: (I18n.locale == I18n.default_locale ? nil : I18n.locale) }
  end

  protected
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      locale = params[:locale].to_s

      if I18n.available_locales.map(&:to_s).include?(locale)
        I18n.locale = locale
      else
        flash.now[:notice] = "#{locale} translation not available"
        logger.error flash.now[:notice]
      end
    else
      I18n.locale = I18n.default_locale
    end
  end
end
