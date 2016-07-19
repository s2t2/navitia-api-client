require "httparty"
require "pry"

# See documentation at http://doc.navitia.io/
module NavitiaAPI
  URL = "api.navitia.io"
  VERSION = "v1"
  #KEY = ENV.fetch("NAVITIA_API_KEY", "Expecting an environment variable called 'NAVITIA_API_KEY'. Aquire one here: http://navitia.io/register/.")
  KEY = "3b036afe-0110-4202-b9ed-99718476c2e0" # personal api key is not working, so use the example key for now...

  def self.base_url
    "https://#{KEY}@#{URL}/#{VERSION}"
  end

  def self.coverage_endpoint
    "#{base_url}/coverage"
  end

  # Example coordinates.
  def self.coords
    {lat: 48.873462, lon: 2.353375}
  end

  def self.coords_str
    "#{coords[:lat]}%3B#{coords[:lon]}" # the ";" should get translated into a "%3B"
  end

  def self.coverage_nearby_endpoint
    return "#{base_url}/coverage/#{coords_str}"
  end

  def self.places_nearby_endpoint
    return "#{base_url}/coord/#{coords_str}/places_nearby"
  end
end

#endpoint = NavitiaAPI.coverage_endpoint
#puts "ENDPOINT -- #{endpoint}"
#response = HTTParty.get(endpoint)
#puts response.body, response.code, response.message, response.headers.inspect

[
  NavitiaAPI.coverage_endpoint,
  NavitiaAPI.coverage_nearby_endpoint,
  NavitiaAPI.places_nearby_endpoint,
].each do |endpoint|
  puts "\n"
  puts "ENDPOINT -- #{endpoint}"
  response = HTTParty.get(endpoint)
  puts "RESULT -- #{response.code}: #{response.message}"
  puts "MESSAGE -- #{JSON.parse(response.body)["message"]}"  #response.headers.inspect, JSON.parse(response.body)
end
