class AuthMailer < ApplicationMailer
  def send_code(code, email)
    @text_mail = code
    mail to: email, subject: "Codigo de verificação"
  end
end
