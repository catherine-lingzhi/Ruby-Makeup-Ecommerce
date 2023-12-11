ActionMailer::Base.smtp_settings = {
  user_name:            "apikey",
  password:             ENV["SENDGRID_API_KEY"],
  domain:               "http://127.0.0.1:3000",
  address:              "smtp.sendgrid.net",
  port:                 587,
  authentication:       :plain,
  enable_starttls_auto: true
}
