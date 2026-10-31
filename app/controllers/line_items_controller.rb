class LineItemsController < ApplicationController
  include CurrentCart
  # include StoreIndexVisitCount

  before_action :set_cart, only: %i[ create update_quantity ]
  before_action :set_line_item, only: %i[ show edit update destroy update_quantity ]

  # GET /line_items or /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1 or /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items or /line_items.json
  def create
    # reset_counter
    product_id = params[:product_id] || params[:line_item][:product_id]
    product = Product.find(product_id)
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.turbo_stream { @current_item = @line_item }
        format.html { redirect_to store_index_url, notice: "Item added to cart" }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @line_item.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /line_items/1 or /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: "Line item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @line_item.errors, status: :unprocessable_content }
      end
    end
  end

  def update_quantity
    @line_item.quantity += params[:num].to_i
    if @line_item.quantity <= 0
      destroy
      return
    end
    notice = params[:num].to_i > 0 ? "Quantity was successfully increased." : "Quantity was successfully decreased."
    respond_to do |format|
      if @line_item.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
          :cart,
          partial: 'layouts/cart',
          locals: { cart: @cart }
          )
        end
        format.html { redirect_to store_index_url, notice: "Item added to cart" }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @line_item.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /line_items/1 or /line_items/1.json
  def destroy
    @line_item.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          :cart,
          partial: 'layouts/cart',
          locals: { cart: @cart }
        )
      end

      format.html do
        redirect_to request.path,
                    notice: "Item removed from cart",
                    status: :see_other
      end

      format.json { head :no_content }
    end
end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.expect(line_item: [ :product_id, :cart_id ])
    end
end
