require "httparty"
require "pry"

#
# TEST API CONNECTION
#

endpoint = "https://3b036afe-0110-4202-b9ed-99718476c2e0@api.navitia.io/v1/coverage"
response = HTTParty.get(endpoint)
puts response.body, response.code, response.message, response.headers.inspect
