require_relative "../lib/navitia_api"

coords = NavitiaAPI::Coords.new
endpoint = NavitiaAPI.places_nearby_endpoint(coords.parameterized)
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts "RESULT -- #{response.code}: #{response.message}"

parsed_body = JSON.parse(response.body)
puts "MESSAGE -- #{parsed_body["message"]}" if parsed_body["message"]

parsed_body["places_nearby"].each do |place|
  puts place[place["embedded_type"]]["id"]
end

#TODO: handle pagination
