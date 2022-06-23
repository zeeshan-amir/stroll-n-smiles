class PanelMailer < ApplicationMailer
  default template_path: 'panel/mailer'

  def welcome(email, password)
    @email = email
    @password = password

    mail(to: @email, subject: 'StrollNSmile - Your admin access')
  end
end
