# Urbica OpenTripPlanner Docker image

[OpenTripPlanner](http://www.opentripplanner.org/) (OTP) is a family of open source software projects that provide passenger information and transportation network analysis services. The core server-side Java component finds itineraries combining transit, pedestrian, bicycle, and car segments through networks built from widely available, open standard OpenStreetMap and GTFS data. This service can be accessed directly via its web API or using a range of Javascript client libraries, including modern reactive modular components targeting mobile platforms.

## Usage

Build the docker image from the Dockerfile:

```shell
docker build -t my_docker_id/otp .
```

Build graphs using GTFS and OSM extract in the current directory:

```shell
docker run \
-v $PWD/graphs:/var/otp/graphs \
-e JAVA_OPTIONS=-Xmx4G \
my_docker_id/otp --build \
--save /var/otp/graphs/city_name
```

Run OTP server by loading the graph, and exposing OTP's port 8080 to our machine's port 8080:

```shell
docker run \
  -p 8080:8080 \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx4G \
  my_docker_id/otp --load /var/otp/graphs/city_name/
```

It seems [Analyst API ](https://docs.opentripplanner.org/en/latest/OTP2-MigrationGuide/#analyst "Analyst API ")have been removed in this version.

## Basic Tutorial

Based on [OpenTripPlanner Basic Tutorial](https://docs.opentripplanner.org/en/latest/Basic-Tutorial/).

### Get some data
Clone this repo to your machine.
```shell
git clone https://github.com/ikespand/docker-otp
cd docker-otp
```
Get GTFS for Transit Schedules and Stops (As a sample for Portland),

```shell
mkdir -p ./graphs/portland
wget "http://developer.trimet.org/schedule/gtfs.zip" -O ./graphs/portland/trimet.gtfs.zip
```

Get OpenStreetMap extract for the streets. osmconvert step is used to reduce the data size, you can skip this step if you've allocated sufficient memory to your docker. Otherwise [download](hthttps://wiki.openstreetmap.org/wiki/Osmconvert#Binariestp:// "download") osmconvert.

```shell
wget http://download.geofabrik.de/north-america/us/oregon-latest.osm.pbf
osmconvert oregon-latest.osm.pbf -b=-123.043,45.246,-122.276,45.652 --complete-ways -o=portland.pbf
mv portland.pbf ./graphs/portland
```

### Start up OTP

Build the docker image from the Dockerfile:

```shell
docker build -t ikespand/otp .
```

Build graphs using GTFS and OSM extract in the current directory:

```shell
docker run \
 -v $PWD/graphs:/var/otp/graphs \
 -e JAVA_OPTIONS=-Xmx4G \
 ikespand/otp --build \
 --save /var/otp/graphs/portland
```

Run OTP server by loading the graph, and exposing OTP's port 8080 to our machine's port 8080:

```shell
docker run \
  -p 8080:8080 \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx4G \
  ikespand/otp --load /var/otp/graphs/portland
```

Alternatively, modify the `docker-compose.yml` and then execute:
```shell
docker-compose up
```
The graph build operation should take about one minute to complete, and then you'll see a Grizzly server running message. At this point you have an OpenTripPlanner server running locally and can open http://localhost:8080/ in a web browser. You should be presented with a web client that will interact with your local OpenTripPlanner instance.

This map-based user interface is in fact sending HTTP GET requests to the OTP server running on your local machine. It can be informative to watch the HTTP requests and responses being generated using the developer tools in your web browser.

### Resources

There are a number of different resources available through the HTTP API. Besides trip planning, OTP can also look up information about transit routes and stops from the GTFS you loaded and return this information as JSON. For example:

- Get a list of all available routers: http://localhost:8080/otp/routers/default/
- Get a list all GTFS routes on the default router: http://localhost:8080/otp/routers/default/index/routes
- Find all stops on TriMet route 52: http://localhost:8080/otp/routers/default/index/routes/TriMet:52/stops
- Find all routes passing though TriMet stop ID 7003: http://localhost:8080/otp/routers/default/index/stops/TriMet:7003/routes
- Return all unique sequences of stops on the TriMet Green rail line: http://localhost:8080/otp/routers/default/index/routes/TriMet:4/patterns

We refer to this as the Index API. It is also documented in the [OTP HTTP API docs](http://dev.opentripplanner.org/apidoc/1.0.0/resource_IndexAPI.html).
