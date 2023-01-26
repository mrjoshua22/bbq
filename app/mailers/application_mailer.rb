class ApplicationMailer < ActionMailer::Base
  default from: ENV["BBQ_MAIL"]
  layout "mailer"
end
