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

  def categories
    @categories = Category.eager_load(:sub_categories)
    render template: "categories/index"
  end
end
