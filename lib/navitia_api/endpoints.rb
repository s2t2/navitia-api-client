module NavitiaAPI
  module Endpoints
    URL = "api.navitia.io"
    VERSION = "v1"
    KEY = ENV.fetch("NAVITIA_API_KEY", "3b036afe-0110-4202-b9ed-99718476c2e0")
    BASE_URL = "https://#{KEY}@#{URL}/#{VERSION}"

    def self.regions
      "#{BASE_URL}/coverage"
    end

    # Get more information about the specified location.
    #
    # @param [NavitiaAPI::Coords.parameterized] coords_param
    def self.coords(coords_param)
      "#{BASE_URL}/coverage/#{coords_param}"
    end

    # Get places near the specified location.
    #
    # @param [NavitiaAPI::Coords.parameterized] coords_param
    def self.places_nearby(coords_param)
      "#{BASE_URL}/coord/#{coords_param}/places_nearby"
    end

    # Get transit schedules near the specified location.
    #
    # @param [NavitiaAPI::Coords.parameterized] coords_param
    def self.stop_schedules(coords_param)
      endpoint = "#{BASE_URL}/coverage/#{coords_param}/coords/#{coords_param}/stop_schedules"
      endpoint += "?from_datetime=#{DateTime.now.strftime("%Y%m%dT%H%M%S")}"
    end
  end
end
