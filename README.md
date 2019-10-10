# Urbica OpenTripPlanner Docker image

[OpenTripPlanner](http://www.opentripplanner.org/) (OTP) is a family of open source software projects that provide passenger information and transportation network analysis services. The core server-side Java component finds itineraries combining transit, pedestrian, bicycle, and car segments through networks built from widely available, open standard OpenStreetMap and GTFS data. This service can be accessed directly via its web API or using a range of Javascript client libraries, including modern reactive modular components targeting mobile platforms.

## Usage

Build graphs using GTFS and OSM extract in the current directory:

```shell
docker run \
  -v $PWD:/graphs \
  -e JAVA_OPTIONS=-Xmx4G \
  urbica/otp --build /graphs
```

Run OTP server:

```shell
docker run \
  -p 8080:8080 \
  -v $PWD:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx4G \
  otp --server --autoScan --verbose
```

...or run OTP server with analyst module:

```shell
docker run \
  -p 8080:8080 \
  -v $PWD:/graphs \
  -e JAVA_OPTIONS=-Xmx4G \
  urbica/otp --basePath /data --server --analyst --autoScan --verbose
```

## Basic Tutorial

Based on [OpenTripPlanner Basic Tutorial](https://opentripplanner.readthedocs.io/en/latest/Basic-Tutorial/).

### Get some data

Get GTFS for Transit Schedules and Stops

```shell
mkdir -p ./graphs/portland
wget "http://developer.trimet.org/schedule/gtfs.zip" -O ./graphs/portland/trimet.gtfs.zip
```

Get OSM extract for Streets

```shell
wget http://download.geofabrik.de/north-america/us/oregon-latest.osm.pbf
osmconvert oregon-latest.osm.pbf -b=-123.043,45.246,-122.276,45.652 --complete-ways -o=portland.pbf
mv portland.pbf ./graphs/portland
```

### Start up OTP

Build graph

```shell
docker run \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx4G \
  urbica/otp --build /var/otp/graphs/portland
```

Run OTP server:

```shell
docker run \
  -p 8080:8080 \
  -v $PWD/graphs:/var/otp/graphs \
  -e JAVA_OPTIONS=-Xmx4G \
  urbica/otp --server --autoScan --verbose
```

The graph build operation should take about one minute to complete, and then you'll see a Grizzly server running message. At this point you have an OpenTripPlanner server running locally and can open http://localhost:8080/ in a web browser. You should be presented with a web client that will interact with your local OpenTripPlanner instance.

This map-based user interface is in fact sending HTTP GET requests to the OTP server running on your local machine. It can be informative to watch the HTTP requests and responses being generated using the developer tools in your web browser.

### Usage

There are a number of different resources available through the HTTP API. Besides trip planning, OTP can also look up information about transit routes and stops from the GTFS you loaded and return this information as JSON. For example:

- Get a list of all available routers: http://localhost:8080/otp/routers/default/
- Get a list all GTFS routes on the default router: http://localhost:8080/otp/routers/default/index/routes
- Find all stops on TriMet route 52: http://localhost:8080/otp/routers/default/index/routes/TriMet:52/stops
- Find all routes passing though TriMet stop ID 7003: http://localhost:8080/otp/routers/default/index/stops/TriMet:7003/routes
- Return all unique sequences of stops on the TriMet Green rail line: http://localhost:8080/otp/routers/default/index/routes/TriMet:4/patterns

We refer to this as the Index API. It is also documented in the [OTP HTTP API docs](http://dev.opentripplanner.org/apidoc/1.0.0/resource_IndexAPI.html).
