require "httparty"
require "pry"

# See documentation at http://doc.navitia.io/
module NavitiaAPI
  URL = "api.navitia.io"
  VERSION = "v1"
  KEY = ENV.fetch("NAVITIA_API_KEY", "Expecting an environment variable called 'NAVITIA_API_KEY'. Aquire one here: http://navitia.io/register/.")

  def self.base_url
    "https://#{KEY}@#{URL}/#{VERSION}"
  end

  def self.coverage_endpoint
    "#{base_url}/coverage"
  end

  # @param [Hash] coords Coordinates like {lat: 48.873462, lon: 2.353375}
  def self.places_nearby_endpoint(coords)
    coords_str = "#{coords[:lat]}%3B#{coords[:lon]}" # the ";" should get translated into a "%3B"
    return "#{base_url}/coord/#{coords_str}/places_nearby"
  end
end

endpoint = NavitiaAPI.coverage_endpoint
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts response.body, response.code, response.message, response.headers.inspect



coords = {lat: 48.873462, lon: 2.353375}
endpoint = NavitiaAPI.places_nearby_endpoint(coords)
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts JSON.parse(response.body), response.code, response.message, response.headers.inspect
