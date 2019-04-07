# BikeSantiago backend

## System overview

The system runs a backend task that polls the [CityBikes api](http://api.citybik.es/v2/networks/bikesantiago) every minute.

Up to date information about each station is stored on the `stations` table and a log entry is stored in the `station_logs` table.

The system also stores the Comunas in Santiago in the `comunas` table. New stations are automatically created and linked to theis appropriate comuna.

## Requirements

#### Ruby version
The system has developed and tested using Ruby version `2.6.2`.

#### System dependencies
The following dependencies are required to run the system:
* Ruby
* Rails
* Postgres, with the postgis extension installed
* Redis

## Getting up an running

* Clone the project
* Install the required dependencies
* Initialize and seed the database (the database is seeded with the comunas)
```sh
rake db:setup
```
* Run the scheduler task
```sh
rake resque:scheduler
```
* Run the worker
```sh
QUEUE=default rake resque:work
```
* Run the server
```sh
rails s
```

## Available endpoints

#### `/api/stations`
Lists all stations

The following url paramaters can be used:
* `name` Search by the station name
* `comuna` Search by the comuna name

Note that the paramaters are exclusive and that name takes presidence

Examples:
```
/api/stations?name=vita
```

```
/api/stations?comuna=providencia
```

#### `/api/usage`
Generates a usage report

The following url paramaters can be used
* `name` Filter by the station name
* `comuna` Filter by the comuna name
* `last` Specity whether the report should be generated for the last `hour` or the last `day`. The default is `hour`

Note that the name and comuna paramaters are exclusive and that name takes presidence.

Examples:
```
/api/usage?name=vita
```

```
/api/usage?name=vita&last=day
```

```
/api/usage?comuna=providencia
```

## Running the tests

```sh
rspec
```
