require "httparty"
require "pry"

# See documentation at http://doc.navitia.io/
module NavitiaAPI
  URL = "api.navitia.io"
  VERSION = "v1"
  KEY = ENV.fetch("NAVITIA_API_KEY", "Expecting an environment variable called 'NAVITIA_API_KEY'. Aquire one here: http://navitia.io/register/.")

  def self.base_url
    "https://#{KEY}@#{URL}/#{VERSION}/"
  end

  def self.coverage_endpoint
    "#{base_url}/coverage"
  end
end

response = HTTParty.get(NavitiaAPI.coverage_endpoint)
puts response.body, response.code, response.message, response.headers.inspect
