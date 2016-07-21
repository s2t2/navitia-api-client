require_relative "../lib/navitia_api"

coords = NavitiaAPI::Coords.new
endpoint = NavitiaAPI.stop_schedules_endpoint(coords.parameterized)
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts "RESULT -- #{response.code}: #{response.message}"
parsed_body = JSON.parse(response.body)
puts "MESSAGE -- #{parsed_body["message"]}" if parsed_body["message"]
#puts parsed_body.keys #> ["stop_schedules", "pagination", "links", "disruptions", "notes", "feed_publishers", "exceptions"]
puts "PAGINATION -- #{parsed_body["pagination"]}" #> {"start_page"=>0, "items_on_page"=>2, "items_per_page"=>10, "total_result"=>2}
#TODO: handle pagination

#
# DISTINGUISH BETWEEN TRANSIT MODES
#

metro_schedules = parsed_body["stop_schedules"].select{|ss| ss["display_informations"]["commercial_mode"] == "Metro"}
bus_schedules = parsed_body["stop_schedules"].select{|ss| ss["display_informations"]["commercial_mode"] == "Bus"}
other_schedules = parsed_body["stop_schedules"] - metro_schedules - bus_schedules
raise "INVESTIGATE #{other_schedules.count} OTHER SCHEDULES" if other_schedules.any?

metro_station_names = metro_schedules.map{|sched| sched["stop_point"]["name"] }.uniq
metro_station_names.each do |station_name|
  puts "\n"
  puts "hello, you are at station #{station_name.downcase}"

  puts "\n"
  puts "-----------"
  puts "next trains"
  puts "-----------"

  metro_schedules.each do |stop_schedule| #> ["stop_point", "links", "date_times", "route", "additional_informations", "display_informations"]
    raise "INVESTIGATE LINE LABEL" unless [ stop_schedule["display_informations"]["code"], stop_schedule["display_informations"]["label"], stop_schedule["display_informations"]["network"] ].uniq != 1

    display = {
      :transportation_method => stop_schedule["display_informations"]["commercial_mode"],
      :line_label => stop_schedule["display_informations"]["label"],
      :line_color => stop_schedule["display_informations"]["color"],
      :line_text_color => stop_schedule["display_informations"]["text_color"],
      :direction_name => stop_schedule["display_informations"]["direction"],
    }

    puts "\n"
    puts "direction: #{display[:direction_name].downcase.gsub("(paris)","")}"
    puts " + line: #{display[:line_label]} (##{display[:line_text_color]} on ##{display[:line_color]})"

    #route = { #> ["direction", "codes", "name", "links", "is_frequence", "geojson", "direction_type", "line", "id"]
    #  :id => stop_schedule["route"]["id"],
    #  :name => stop_schedule["route"]["name"],
    #  :line => { #> ["code", "name", "links", "physical_modes", "opening_time", "geojson", "text_color", "color", "codes", "closing_time", "routes", "commercial_mode", "id", "network"]
    #    :id => stop_schedule["route"]["line"]["id"],
    #    :code=> stop_schedule["route"]["line"]["code"],
    #    :name => stop_schedule["route"]["line"]["name"],
    #    :text_color => stop_schedule["route"]["line"]["text_color"],
    #    :color => stop_schedule["route"]["line"]["color"],
    #    :route_count => stop_schedule["route"]["line"]["routes"].count
    #  },
    #  :direction => { #> ["embedded_type", "quality", "stop_area", "name", "id"]
    #    :id => stop_schedule["route"]["direction"]["id"],
    #    :name => stop_schedule["route"]["direction"]["name"]
    #  }
    #}
  end
end
