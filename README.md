# Urbica OpenTripPlanner Docker image

[OpenTripPlanner](http://www.opentripplanner.org/) (OTP) is a family of open source software projects that provide passenger information and transportation network analysis services. The core server-side Java component finds itineraries combining transit, pedestrian, bicycle, and car segments through networks built from widely available, open standard OpenStreetMap and GTFS data. This service can be accessed directly via its web API or using a range of Javascript client libraries, including modern reactive modular components targeting mobile platforms.

## Usage

Build graphs using GTFS and OSM extract in the current directory:

```shell
docker run -e JAVA_OPTIONS=-Xmx4G -v $PWD:/graphs urbica/otp --build /graphs
```

Run OTP server with analyst module:

```shell
docker run -e JAVA_OPTIONS=-Xmx4G -v $PWD:/data/graphs -p 8080:8080 urbica/otp --basePath /data --server --analyst --autoScan --verbose
```
