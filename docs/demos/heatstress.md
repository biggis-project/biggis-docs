# Heatstress Routing App

!!! TODO
    **Julian's student** - related repository is https://github.com/biggis-project/path-optimizer

## Related Scenarios
- [Smart City](../scenarios/01_city.md)


## Back-end REST-API

The back-end exposes a simple REST-API, that can be used for routing or to find the optimal point in time.

## General information

The rest api can be accessed on `http://localhost:8080/heatstressrouting/api/v1`. JSON is supported as the only output format.

## Server information

* **URL:** `http://localhost:8080/heatstressrouting/api/v1/info`

* **Description:** returns some information about the running service, e.g. the supported area and time range

* **Parameter:** the `/info` site takes no parameter 

* **Returns:** some information about the running service (see sample response below):

	* `bbox`: the bounding box of the area supported by the service as an array of `[min_lat, min_lng, max_lat, max_lng]`.
	* `time_range`: the time range supported by the service, given as time stamps of the form `2014-08-23T00:00`.
	* `place_types`: a list of place types supported by the optimal time api

* **Example:**

	* **Sample Request:** `http://localhost:8080/heatstressrouting/api/v1/info`
	* **Sample Response:**
```json
{
    "service":"heat stress routing",
    "version":"0.0.1-SNAPSHOT",
    "build_time":"2016-09-27T07:50:42Z",
    "bbox":[
        48.99,
        8.385,
        49.025,
        8.435
    ],
    "time_range":{
        "from":"2014-08-23T00:00",
        "to":"2016-02-23T23:00"
    },
    "place_types":[
        "bakery",
        "taxi",
        "post_office",
        "ice_cream",
        "dentist",
        "post_box",
        "supermarket",
        "toilets",
        "bank",
        "cafe",
        "police",
        "doctors",
        "pharmacy",
        "drinking_water",
        "atm",
        "clinic",
        "kiosk",
        "hospital",
        "chemist",
        "fast_food"
    ]
}
```

## Routing

* **URL:** `http://localhost:8080/heatstressrouting/api/v1/routing`

* **Description:** Computes the optimal route (regarding heat stress) between a start and a destination at a given time.

* **Parameter:** the `/routing` api supports the following parameter (some are optional):

	* `start`: the start point as pair of a latitude value and longitude value (in that order) seperated by a comma, e.g. `start=49.0118083,8.4251357`. 
	* `destination`: the destination as pair of a latitude value and longitude value (in that order) seperated by a comma, e.g. `destination=49.0126868,8.4065707`. 
	* `time`: the date and time the optimal route should be searched for; a time stamp of the form `YYYY-MM-DDTHH:MM:SS`, e.g. `time=2015-08-31T10:00:00`. The value must be in the time range returned by `/info` (see [above](#server-information)).
	* `weighting` (optional): the weightings to be used; a comma seperated list of the supported weightings (`shortest`, `heatindex` and `temperature`), e.g. `weighting=shortest,heatindex,temperature`; the default is `weighting=shortest,heatindex`; the results for the `shortest` weighting are always returned, even if the value is omited in the weighings list.

* **Returns:** the path and some other information for each of the weightings:
  
  * `status`: the status of the request; `OK` is everthing is okay, `BAD_REQUEST` if a invalid request was send or `INTERNAL_SERVER_ERROR` if an internal error occoured.
  * `status_code`: the HTTP status code returned.
  * `results`: the results for each weighting:
    * `weighting`: the weighting used for that result (see parameter `weighting` above).
    * `start`: the coordinates of the start point as array of `[lat, lng]`.
    * `destination`: the coordinates of the destination as array of `[lat, lng]`.
    * `distance`: the length of the route in meter.
    * `duration`: the walking time in milli seconds.
    * `route_weights`: the route weights of the selected weightings for the route.
    * `path`: the geometry of the path found; an array of points, were each point is an array of [lat, lng]`.
    
* **Example:**
  * **Sample Request:** `http://localhost:8080/heatstressrouting/api/v1/routing?start=49.0118083,8.4251357&destination=49.0126868,8.4065707&time=2015-08-31T10:00:00&weighting=shortest,heatindex,temperature`
  * **Sample Response:**
```json
{
    "status":"OK",
    "status_code":200,
    "results":{
        "shortest":{
            "weighting":"shortest",
            "start":[
                49.0118083,
                8.4251357
            ],
            "destination":[
                49.0126868,
                8.4065707
            ],
            "distance":1698.2989202985977,
            "duration":1222740,
            "route_weights":{
                "temperature":50903.955833052285,
                "heatindex":50892.20496302502,
                "shortest":1698.2989202985977
            },
            "path":[
                [
                    49.01190564077309,
                    8.4250437301107
                ],
                [
                    49.01225359765262,
                    8.425994591995952
                ],
                // points omitted ...
                [
                    49.01272775130067,
                    8.406514897340614
                ]
            ]
        },
        "heatindex":{
            "weighting":"heatindex",
            "start":[
                49.0118083,
                8.4251357
            ],
            "destination":[
                49.0126868,
                8.4065707
            ],
            "distance":1901.8839202985973,
            "duration":1369323,
            "route_weights":{
                "temperature":51868.74807902536,
                "heatindex":51098.277424417196,
                "shortest":1901.8839202985978
            },
            "path":[
                [
                    49.01190564077309,
                    8.4250437301107
                ],
                [
                    49.01225359765262,
                    8.425994591995952
                ],
                // points omitted ...
                [
                    49.01272775130067,
                    8.406514897340614
                ]
            ]
        },
        "temperature":{
            "weighting":"temperature",
            "start":[
                49.0118083,
                8.4251357
            ],
            "destination":[
                49.0126868,
                8.4065707
            ],
            "distance":1901.8839202985973,
            "duration":1369323,
            "route_weights":{
                "temperature":51868.74807902536,
                "heatindex":51098.277424417196,
                "shortest":1901.8839202985978
            },
            "path":[
                [
                    49.01190564077309,
                    8.4250437301107
                ],
                [
                    49.01225359765262,
                    8.425994591995952
                ],
                // points omitted ...
                [
                    49.01272775130067,
                    8.406514897340614
                ]
            ]
        }
    }
}
``` 

## Optimal time

* **URL:** `http://localhost:8080/heatstressrouting/api/v1/optimaltime`

* **Description:** Performce a nearby search for a given start point and computes for every place that fulfills a specified criterion an optimal point in time, i.e. the time with the minimal heat stress.

* **Parameter:** the `/optimaltime` api supports the following parameter (some are optional):

	* `start`: the start point as pair of a latitude value and longitude value (in that order) seperated by a comma, e.g. `start=49.0118083,8.4251357`. 
	* `time`: the date and time the optimal route should be searched for; a time stamp of the form `YYYY-MM-DDTHH:MM:SS`, e.g. `time=2015-08-31T10:00:00`. The value must be in the time range returned by `/info` (see [above](#server-information)).
	* `place_type`: the place type to search for; a comma seperated list of supported place types, e.g. `place_type=supermarket,chemist`; a complete list of supported place list can be queried using the `info` api (see [above](#server-information)). Currently the following place tyes are supported: `bakery`, `taxi`, `post_office`, `ice_cream`, `dentist`, `post_box`, `supermarket`, `toilets`, `bank`, `cafe`, `police`, `doctors`, `pharmacy`, `drinking_water`, `atm`, `clinic`, `kiosk`, `hospital`, `chemist`, `fast_food`. The place types are mapped to the corresponding [`shop`](http://wiki.openstreetmap.org/wiki/Key:shop) respectively [`amenity`](http://wiki.openstreetmap.org/wiki/Key:amenity) tags.
	* `max_results` (optional): the maximum number of results to consider for the nearby search (an positive integer), e.g. `max_results=10`; the default value is 5.
	* `max_distance` (optional): the maximum direct distance (as the crow flies) between the start point and the place in meter, e.g. `max_distance=500.0`; the default value is 1000.0 meter.
	* `time_buffer` (optional): the minimum time needed at the place (in minutes), i.e. the optimal time is chossen so that the place is opened for a least `time_buffer` when the user arrives, e.g. `time_buffer=30`; the default value is 15 miniutes.
	* `earliest_time` (optional): the earliest desired time, either a time stamp, e.g. `earliest_time=2015-08-31T09:00` or the string `null` (case is ignored); the default value is `null`. If both `earliest_time` and `latest_time` are specified, `earliest_time` must be before `latest_time`.
	* `latest_time` (optional): the latest desired time, either a time stamp, e.g. `latest_time=2015-08-31T17:00` or the string `null` (case is ignored); the default value is `null`. If both `earliest_time` and `latest_time` are specified, `earliest_time` must be before `latest_time`; `latest_time` must be after `time`.

* **Returns:** the optimal point in time for each place found in the specified radius ranked by the optimal-value:

  * `status`: the status of the request; `OK` if everthing is okay, `NO_REULTS` if not results were found, `BAD_REQUEST` if a invalid request was send to the server or `INTERNAL_SERVER_ERROR` if an internal server error occoured.
  * `status_code`: the HTTP status code returned.
  * `results`: the result for each place found during the nearby search:
  
    * `rank`: the rank of the place according to the optimal value (were 1 is the best rank).
    * `name`: the name of the place.
    * `osm_id`: the [OpenStreetMap Node ID](http://wiki.openstreetmap.org/wiki/Node) of the place.
    * `location`: the coordinates of the places as an array of `[lat, lng]`.
    * `opening_hours`: the opening hours of the place; the format specification can be found [here](http://wiki.openstreetmap.org/wiki/Key:opening_hours/specification).
    * `optimal_time`: the optimal point in time found for that place, e.g. `2015-08-31T20:00`
    * `optimal_value`: the optimal value found for the place; the value considering the heat stress acording to steadman's heatindex [(Steadmean, 1979)](http://dx.doi.org/10.1175/1520-0450(1979)018%3C0861:taospi%3E2.0.co;2) as well as the distance between the start and the place.
    * `distance`: the length of the optimal path (see [Routing](#routing) above) from the start to the place in meter.
    * `duration`: the time needed to walk from the start to the place (in milli seconds).
    * `path_optimal`: the geometry of the optimal path (see [Routing](#routing) above).
    * `distance_shortest`: the length of the shortest path between the start and the place (in meter).
    * `duration_shortest`: the time needed to walk the shortest path between the start and the place (in milli seconds).
    * `path_optimal`: the geometry of the shortest path (see [Routing](#routing) above).
    
* **Example:**
  * **Sample Request:** `http://localhost:8080/heatstressrouting/api/v1/optimaltime?start=49.0118083,8.4251357&time=2015-08-31T10:00:00&place_type=supermarket&max_distance=1000&max_results=5&time_buffer=15&earliest_time=2015-08-31T09:00:00&latest_time=2015-08-31T20:00:00`
  * **Sample Response:**
```json
{
    "status":"OK",
    "status_code":200,
    "results":[
        {
            "rank":1,
            "name":"Rewe City",
            "osm_id":897615202,
            "location":[
                49.0096613,
                8.4237272
            ],
            "opening_hours":"Mo-Sa 07:00-22:00; Su,PH off",
            "optimal_time":"2015-08-31T20:00",
            "optimal_value":12515.36230258099,
            "distance":539.1839746027457,
            "duration":388207,
            "path_optimal":[
                [
                    49.01190564077309,
                    8.4250437301107
                ],
                [
                    49.011967867880344,
                    8.425196821060705
                ],
                // points omitted ...
                [
                    49.00954480942009,
                    8.423681942364334
                ]
            ],
            "distance_shortest":468.99728441805115,
            "duration_shortest":337669,
            "path_shortest":[
                [
                    49.01190564077309,
                    8.4250437301107
                ],
                [
                    49.011967867880344,
                    8.425196821060705
                ],
                // points omitted ...
                [
                    49.00954480942009,
                    8.423681942364334
                ]
            ]
        },
        {
            "rank":2,
            "name":"Oststadt Super-Bio-Markt",
            "osm_id":931682116,
            "location":[
                49.009433,
                8.4234214
            ],
            "opening_hours":"Mo-Fr 09:00-13:00,14:00-18:30; Sa 09:00-13:00",
            "optimal_time":"2015-08-31T18:09:19.199",
            "optimal_value":14318.962937267655,
            "distance":473.346750294328,
            "duration":340801,
            "path_optimal":[
                [
                    49.01190564077309,
                    8.4250437301107
                ],
                [
                    49.011967867880344,
                    8.425196821060705
                ],
                // points omitted ...
                [
                    49.00944708743373,
                    8.4235711322383
                ]
            ],
            "distance_shortest":473.346750294328,
            "duration_shortest":340801,
            "path_shortest":[
                [
                    49.01190564077309,
                    8.4250437301107
                ],
                [
                    49.011967867880344,
                    8.425196821060705
                ],
                // points omitted ...
                [
                    49.00944708743373,
                    8.4235711322383
                ]
            ]
        }
    ]
}
```

## Error messages:

If an error occurs, e.g. because a bade request were send to the server or an internal server errors occurs, the server is sending a JSON response with the following content:

* `status`: the status of the request; `OK` if everthing is okay, `NO_REULTS` if not results were found, `BAD_REQUEST` if a invalid request was send to the server or `INTERNAL_SERVER_ERROR` if an internal server error occoured.
* `status_code`: the HTTP status code returned.
* `messages`: an array of human readable error messages.

**Example:**

* *Example Request:* `http://localhost:8080/heatstressrouting/api/v1/optimaltime?start=Schloss,%20Karlsruhe&time=2015-08-31T10:00:00&place_type=supermarket`
* *Example Response:* 
```json
{
    "status":"BAD_REQUEST",
    "status_code":400,
    "messages":[
        "start (Schloss, Karlsruhe) could not be parsed: failed to parse coordinate; 'start' must be a pair of latitude and longitude seperated by a comma (','), e.g. '49.0118083,8.4251357')"
    ]
}
``` 

# References

!!! cite "Reference"
    Steadman, R. G. **The Assessment of Sultriness. Part I: A Temperature-Humidity Index Based on Human Physiology and Clothing.**
    Science Journal of Applied Meteorology, 1979, 18, 861-873, DOI: 10.1175/1520-0450(1979)018<0861:TAOSPI>2.0.CO;2