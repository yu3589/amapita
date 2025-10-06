require "rakuten_web_service"

RakutenWebService.configure do |config|
  config.application_id = ENV["RAKUTEN_APPLICATION_ID"]
end
