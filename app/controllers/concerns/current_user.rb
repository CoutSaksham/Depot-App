module CurrentUser
  private def set_current_user
    @user = User.find(session[:user_id])
  end
end