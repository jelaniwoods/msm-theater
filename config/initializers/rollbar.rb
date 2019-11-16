Rollbar.configure do |config|
  if Rails.env.production?
    config.enabled = true
    config.access_token = ENV["ROLLBAR_TOKEN"]
  else
    config.enabled = false
  end

  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env
end
