# Navitia.io API Client

This repository contains scripts for exploring the [Navitia.io](http://www.navitia.io/) [API](http://doc.navitia.io/).

## Prerequisites

[Aquire a Navitia API Key](http://navitia.io/register/) and set it as an environment variable called `NAVITIA_API_KEY`.

## Installation

```` sh
git clone git@github.com:s2t2/navitia-api-client.git
cd navitia-api-client/
bundle install
````

## Usage

Get places near the *Bibliothèque François Mitterrand* station.

```` sh
ruby script/get_nearby_places.rb
````

Get transit schedules near the *Bibliothèque François Mitterrand* station.

```` sh
ruby script/get_stop_schedules.rb
````
