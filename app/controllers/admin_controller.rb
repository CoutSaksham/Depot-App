class AdminController < ApplicationController
  RECENT_ORDERS_WINDOW = 5

  before_action :ensure_user_is_admin

  def index
    @total_orders = Order.count
    from = params[:from] || Date.current - RECENT_ORDERS_WINDOW
    to = params[:to] || Date.current
    if to < from
      flash[:notice] = "End date cannot be less than start date"
    end
    @recent_orders = Order.by_date(from = from, to = to)
  end

  def show
  end

  private def ensure_user_is_admin
    unless User.find(session[:user_id]).role == 'admin'
      flash[:notice] = "You don't have privilege to access this section"
      redirect_to "/"
    end
  end
end
