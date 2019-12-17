module Api
  class SendEmailsController < BaseController

    api :POST,
        "/send_emails",
        "send an email"
    param :email, String

    def create
      UserMailer.send_email_to(
        params[:email]).deliver_now
      render nothing: true,
              status: :accepted
    end
  end
end
