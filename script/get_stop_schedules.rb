require_relative "../lib/navitia_api"

coords = NavitiaAPI::Coords.new
endpoint = NavitiaAPI.stop_schedules_endpoint(coords.parameterized)
puts "ENDPOINT -- #{endpoint}"

response = HTTParty.get(endpoint)
puts "RESULT -- #{response.code}: #{response.message}"

parsed_body = JSON.parse(response.body)
puts "MESSAGE -- #{parsed_body["message"]}" if parsed_body["message"]

puts parsed_body.keys #> ["stop_schedules", "pagination", "links", "disruptions", "notes", "feed_publishers", "exceptions"]

puts parsed_body["pagination"] #> {"start_page"=>0, "items_on_page"=>2, "items_per_page"=>10, "total_result"=>2}
#TODO: handle pagination

puts "\n"
puts "\n"

stlaz = parsed_body["stop_schedules"].first
#puts stlaz.keys #> ["stop_point", "links", "date_times", "route", "additional_informations", "display_informations"]
#puts stlaz["stop_point"].keys #> ["codes", "name", "links", "physical_modes", "coord", "label", "equipments", "commercial_modes", "administrative_regions", "id", "stop_area"]
#puts stlaz["date_times"].count #> 328
#puts stlaz["route"].keys #> ["direction", "codes", "name", "links", "is_frequence", "geojson", "direction_type", "line", "id"]
puts stlaz["route"]["id"] #> "route:RAT:M14_R"
puts stlaz["route"]["name"] #> "Olympiades - Gare Saint-Lazare"
#puts stlaz["route"]["line"].keys #> ["code","name","links","physical_modes","opening_time","geojson","text_color","color","codes","closing_time","routes","commercial_mode","id","network"]
puts stlaz["route"]["line"]["id"] #> "line:RAT:M14"
puts stlaz["route"]["line"]["name"] #> "Olympiades - Gare Saint-Lazare"

puts "\n"
puts "\n"

olymp = parsed_body["stop_schedules"].last
#puts olymp.keys #> ["stop_point", "links", "date_times", "route", "additional_informations", "display_informations"]
#puts olymp["stop_point"].keys #> ["codes", "name", "links", "physical_modes", "coord", "label", "equipments", "commercial_modes", "administrative_regions", "id", "stop_area"]
#puts olymp["date_times"].count #> 328
#puts olymp["route"].keys #> ["direction", "codes", "name", "links", "is_frequence", "geojson", "direction_type", "line", "id"]
puts olymp["route"]["id"] #> "route:RAT:M14"
puts olymp["route"]["name"] #> "Olympiades - Gare Saint-Lazare"
#puts olymp["route"]["line"].keys #> ["code","name","links","physical_modes","opening_time","geojson","text_color","color","codes","closing_time","routes","commercial_mode","id","network"]
puts olymp["route"]["line"]["id"] #> "line:RAT:M14"
puts olymp["route"]["line"]["name"] #> "Olympiades - Gare Saint-Lazare"
