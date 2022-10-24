class Users::Mailer < Devise::Mailer
  default from: ENV["APP_NAME"]
end
