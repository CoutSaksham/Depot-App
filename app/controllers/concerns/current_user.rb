module CurrentUser
  private def set_current_user
    @user = User.find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "User not found!"
  end
end
