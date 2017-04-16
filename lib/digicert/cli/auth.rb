require "dotenv/load"

Digicert.configure do |config|
  config.api_key = ENV["DIGICERT_API_KEY"]
  config.response_type = "hash"
end
