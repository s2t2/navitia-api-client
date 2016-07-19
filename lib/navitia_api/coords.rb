module NavitiaAPI
  class Coords
    BIBLIOTHEQUE_MITTERRAND_STATION = {:lat => "48.8298", :lon => "2.3768"}

    # @example NavitiaAPI::Coords.new({lat: 48.873462, lon: 2.353375})
    def initialize(options = {})
      @lat = options[:lat] || BIBLIOTHEQUE_MITTERRAND_STATION[:lat]
      @lon = options[:lon] || BIBLIOTHEQUE_MITTERRAND_STATION[:lon]
    end

    def parameterized
      "#{@lon};#{@lat}"
    end
  end
end
