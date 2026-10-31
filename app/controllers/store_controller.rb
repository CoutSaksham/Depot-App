class StoreController < ApplicationController
  # include StoreIndexVisitCount
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
    @cart_id = set_cart
    # update_counter
  end
end
