require_relative "../lib/navitia_api"

coords = NavitiaAPI::Coords.new
endpoint = NavitiaAPI.places_nearby_endpoint(coords.parameterized)
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts "RESULT -- #{response.code}: #{response.message}"
puts "MESSAGE -- #{JSON.parse(response.body)["message"]}" if JSON.parse(response.body)["message"] #response.headers.inspect, JSON.parse(response.body)
parsed_body = JSON.parse(response.body)
parsed_body.keys.each do |k|
  puts k.upcase
  pp parsed_body[k]
end
