class SupportRequestMailer < ApplicationMailer
  def respond(support_request)
    @support_request = support_request

    mail(
      to: @support_request.email,
      subject: "Response to your support request"
    )
  end
end
