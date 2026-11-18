class UserMailer < ApplicationMailer
  def greet(user)
    @user = user
    mail(
      to: @user.email,
      subject: t('.welcome')
    )
  end
end
