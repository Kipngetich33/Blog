class ApplicationMailer < ActionMailer::Base
  # default from: "khalifngeno@gmail.com"
  # layout "mailer"
  include SendGrid
end
