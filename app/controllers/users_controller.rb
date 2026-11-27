class UsersController < ApplicationController
  include Pagy::Method
  include CurrentCart
  include CurrentUser

  ORDERS_PER_PAGE = 5
  LINE_ITEMS_PER_PAGE = 5

  before_action :load_user, only: %i[ show edit update destroy ]
  before_action :set_current_user, only: %i[ orders line_items ]
  before_action :set_cart, only: %i[ line_items ]

  layout "my_orders", only: %i[ orders line_items ]

  # GET /users or /users.json
  def index
    @users = User.order(:name)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.build_address
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: "User #{@user.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, notice: @user.errors.full_messages.to_sentence, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    else
      redirect_to users_path,
                notice: @user.errors.full_messages.to_sentence,
                status: :see_other
    end
  end

  def orders
    @pagy, @orders = pagy(@user.orders, limit: ORDERS_PER_PAGE)
  end

  def line_items
<<<<<<< HEAD
<<<<<<< HEAD
    @pagy, @line_items = pagy(@user.line_items, limit: LINE_ITEMS_PER_PAGE)
=======
    @pagy, @line_items = pagy(@user.line_items + @cart.line_items, limit: LINE_ITEMS_PER_PAGE)
>>>>>>> d1761c4 (Still working)
=======
    @pagy, @line_items = pagy(@user.line_items + @cart.line_items, limit: LINE_ITEMS_PER_PAGE)
>>>>>>> 55f1e8a7005fb97ca1a9d3738b08f830e62a7054
  end

  rescue_from "User::Error" do |exception|
    redirect_to users_url, notice: exception.message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def load_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :name, :email, :password, :password_confirmation, address_attributes: [ :street, :city, :state, :country, :pincode ]])
    end
end
