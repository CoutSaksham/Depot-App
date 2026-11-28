class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authorize

  before_action :increment_hit_counter

  around_action :measure_response_time

  before_action :check_inactivity_timeout

  private def ensure_user_is_admin
    unless User.find(session[:user_id]).role == 'admin'
      flash[:notice] = "You don't have privilege to access this section"
      redirect_to "/"
    end
  end

  private def check_inactivity_timeout
    return unless session[:user_id]

    if session[:last_activity_at].present? &&
      Time.current - Time.zone.at(session[:last_activity_at]) > 5.minutes
      session.delete(:user_id)
      session.delete(:last_activity_at)
      redirect_to login_path, alert: "You have been logged out due to inactivity."
    else
      session[:last_activity_at] = Time.current.to_f
    end
  end

  private def measure_response_time
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    yield

    duration = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000

    response.headers["X-Responded-In"] = "#{duration.round(2)}ms"
  end

  private def increment_hit_counter
    Rails.cache.increment("total_page_hits", 1, initial: 0)
  end

  protected
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end
end
