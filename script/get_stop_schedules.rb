require "httparty"
require "pry"

require_relative "../lib/navitia_api"

def arrival_time_label(datetime)
  seconds_from_now = datetime.to_time - DateTime.now.to_time
  minutes_from_now = (seconds_from_now / 60).floor
  return "arriving" if minutes_from_now <= 1
  return "#{minutes_from_now.to_s} mins"
end

coords = NavitiaAPI::Coords.new
endpoint = NavitiaAPI::Endpoints.stop_schedules(coords.parameterized)
puts "ENDPOINT -- #{endpoint}"
response = HTTParty.get(endpoint)
puts "RESULT -- #{response.code}: #{response.message}"
parsed_body = JSON.parse(response.body)
puts "MESSAGE -- #{parsed_body["message"]}" if parsed_body["message"]
#puts parsed_body.keys #> ["stop_schedules", "pagination", "links", "disruptions", "notes", "feed_publishers", "exceptions"]
puts "PAGINATION -- #{parsed_body["pagination"]}" #> {"start_page"=>0, "items_on_page"=>2, "items_per_page"=>10, "total_result"=>2}
#TODO: handle pagination

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

  metro_schedules = metro_schedules.select{|sched| sched["stop_point"]["name"] == station_name }
  metro_schedules.each do |stop_schedule| #> ["stop_point", "links", "date_times", "route", "additional_informations", "display_informations"]
    di = stop_schedule["display_informations"]
    line_labels = [ di["code"], di["label"] ]
    raise "INVESTIGATE LINE LABEL(S) -- #{line_labels.uniq}" unless line_labels.uniq.count == 1
    display = {
      :transportation_method => di["commercial_mode"],
      :line_label => di["label"],
      :line_color => di["color"],
      :line_text_color => di["text_color"],
      :direction_name => di["direction"],
    }

    puts "\n"
    puts "direction: #{display[:direction_name].downcase.gsub("(paris)","")}"
    puts "  line: #{display[:line_label]} (##{display[:line_text_color]} on ##{display[:line_color]})"

    departures = stop_schedule["date_times"].map{|dt| DateTime.parse(dt["date_time"]) }
    upcoming_departures = departures.sort.first(2)
    upcoming_departure_labels = upcoming_departures.map{|dt| arrival_time_label(dt) }

    puts "    next trains arriving in: #{upcoming_departure_labels.first} and #{upcoming_departure_labels[1]}"

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
