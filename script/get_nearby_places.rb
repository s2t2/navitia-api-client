require "httparty"
require "pry"

require_relative "../lib/navitia_api"

coords = NavitiaAPI::Coords.new
endpoint = NavitiaAPI::Endpoints.places_nearby(coords.parameterized)
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts "RESULT -- #{response.code}: #{response.message}"

parsed_body = JSON.parse(response.body)
puts "MESSAGE -- #{parsed_body["message"]}" if parsed_body["message"]

puts parsed_body["pagination"] #> {"start_page"=>0, "items_on_page"=>10, "items_per_page"=>10, "total_result"=>70}
#TODO: handle pagination

parsed_body["places_nearby"].each do |place|
  puts place[place["embedded_type"]]["id"] #> e.g. "poi:w229220455" or "stop_area:RAT:SA:BFMIT" or "stop_point:RAT:SP:BFMIT2"
end
