require_relative "../lib/navitia_api"
require_relative "../lib/navitia_api/coords"

coords = NavitiaAPI::Coords.new
endpoint = NavitiaAPI.places_nearby_endpoint(coords.parameterized)
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts "RESULT -- #{response.code}: #{response.message}"
puts "MESSAGE -- #{JSON.parse(response.body)["message"]}" if JSON.parse(response.body)["message"] #response.headers.inspect, JSON.parse(response.body)
pp JSON.parse(response.body)
