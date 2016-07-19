require "httparty"
require "pry"

# See documentation at http://doc.navitia.io/
module NavitiaAPI
  URL = "api.navitia.io"
  VERSION = "v1"
  #KEY = ENV.fetch("NAVITIA_API_KEY", "Expecting an environment variable called 'NAVITIA_API_KEY'. Aquire one here: http://navitia.io/register/.")
  KEY = "3b036afe-0110-4202-b9ed-99718476c2e0" # personal api key is not working for all endpoints at this time, so using the example key for now...

  def self.base_url
    "https://#{KEY}@#{URL}/#{VERSION}"
  end

  #
  # ENDPOINTS
  #

  def self.regions_endpoint
    "#{base_url}/coverage"
  end

  def self.region_endpoint
    "#{base_url}/coverage/#{region_id}"
  end

  def self.coords_endpoint
    "#{base_url}/coverage/#{coords_param}"
  end

  def self.places_nearby_endpoint1
    "#{base_url}/coord/#{coords_param}/places_nearby"
  end

  def self.places_nearby_endpoint2
    "#{base_url}/coverage/#{coords_param}/coords/#{coords_param}/places_nearby"
  end

  def self.places_nearby_endpoint3
    "#{base_url}/coverage/#{region_id}/coords/#{coords_param}/places_nearby"
  end

  ##def self.places_nearby_endpoint4
  ##  "#{base_url}/coverage/#{region_id}/#{resource_path}/places_nearby"
  ##end

  #
  # METHODS TO BE MOVED ELSEWHERE...
  #

  def self.region_id
    "sandbox"
  end

  def self.coords
    {lat: 48.873462, lon: 2.353375}
  end

  def self.coords_param
    "#{coords[:lon]};#{coords[:lat]}"
  end
end

[
  NavitiaAPI.regions_endpoint,
  NavitiaAPI.region_endpoint,
  NavitiaAPI.coords_endpoint,
  NavitiaAPI.places_nearby_endpoint1,
  NavitiaAPI.places_nearby_endpoint2,
  NavitiaAPI.places_nearby_endpoint3,
  ##NavitiaAPI.places_nearby_endpoint4
].each do |endpoint|
  puts "\n"
  puts "ENDPOINT -- #{endpoint}"
  response = HTTParty.get(endpoint)
  puts "RESULT -- #{response.code}: #{response.message}"
  puts "MESSAGE -- #{JSON.parse(response.body)["message"]}" if JSON.parse(response.body)["message"] #response.headers.inspect, JSON.parse(response.body)
  #pp JSON.parse(response.body)
end
