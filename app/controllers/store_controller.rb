class StoreController < ApplicationController
  skip_before_action :authorize
  include StoreIndexVisitCount
  include CurrentCart
  before_action :set_cart
  def index
    if params[:set_locale]
      redirect_to store_index_path(locale: params[:set_locale])
      nil
    else
      @products = Product.order(:title)
      @cart_id = set_cart
      update_counter
    end
  end
end
