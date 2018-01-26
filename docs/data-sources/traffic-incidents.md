# Traffic Incidents 

## Foundations

The traffic incidents contained for various analytical use cases within the BigGIS projects are gathered via the Bing API (Documentation is online: https://msdn.microsoft.com/en-us/library/hh441726.aspx). The JSON API provides data in real time about traffic incidents (Accidents, traffic congestion, construction etc.). It supports requests using either bounding boxes or route location codes. For our data gathering, we used bounding boxes worldwide and gathered the data in near real time in our database. The API returns coordinates (lat, lon), type of incident, severity (slow-down, all lanes closed etc.), estimated delay as well as start time and estimated end time. All gathered worldwide Bing Traffic Data is available in the BigGIS Database hosted at the University of Konstanz. The table values values are documented below. 

## Statistics

The database contains 3,7 million entries, each containing a unique ID, location information, start and end time as well as describing meta information such as a textual description, the type of incident and the severity. 

### Incident Types

Integer value in Range 1-11 with the following mappings:

1: Accident

2: Congestion

3: DisabledVehicle

4: MassTransit

5: Miscellaneous

6: OtherNews

7: PlannedEvent

8: RoadHazard

9: Construction

10: Alert

11: Weather

### Severity 

Integer value in Range 1-4:

1: LowImpact

2: Minor

3: Moderate

4: Serious

