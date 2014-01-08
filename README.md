YOURS
=====

Objective-C class for accessing [Yet another OpenStreetMap Route Service](http://wiki.openstreetmap.org/wiki/YOURS#API_documentation) that provides routing API based on OSM.

The result of requests is a parsed to `NSDictionary` [GeoJSON](http://geojson.org/) LineString object with properties (which is wrong by the standard).

## Installation
Just drag&drop the ```YoursAPI.h``` and ```YoursAPI.m``` file in your XCode Project. 

Or with **Cocoapods**

	pod 'YOURS', :git => "https://github.com/MrZoidberg/YOURS.git"

## Dependencies

YOURS depends on CoreLocation and [AFNetworking 2.x](https://github.com/AFNetworking/AFNetworking)

## ARC

YOURS is ARC only and works on iOS >= 6.0

## Changelog

- Master branch

## API limitations

YOURS fair use policy prohibits more then 1 request per second for sustained periods of time. API users (IP addresses or applications) that violate this FUP will be blocked. To support this policy this library puts all requests for one for `YoursAPI` class in a serial queue, however you can override this behavious by setting `[[YoursAPI sharedInstance] setEnforceFairUsePolicy:NO];`

## Usage

	//Set response language and client info

	[[YoursAPI sharedInstance] setResponseLanguage:@"en"];
    [[YoursAPI sharedInstance] setClientInfo:@"YOUR_APP_WEBSITE"];

    //Make a request. The result is parsed GeoJSON LineString with properties

    [[YoursAPI sharedInstance] calcRouteFromLocation:userLocation toLocation:targetLocation success:^(NSDictionary *response) {
                
        NSDictionary *routeProps = [response objectForKey:@"properties"];
        NSString *distanceInKm = [routeProps objectForKey:@"distance"];
        NSString *traveltimeInSeconds = [routeProps objectForKey:@"traveltime"];
                
    } failure:^(NSError *error){
        NSLog(@"Cannot calculate route: %@", [error localizedDescription]);
    }];

## Results example

	{
	   "type":"LineString",
	   "crs":{
	      "type":"name",
	      "properties":{
	         "name":"urn:ogc:def:crs:OGC:1.3:CRS84"
	      }
	   },
	   "coordinates":[
	      [
	         36.230035,
	         50.006553
	      ],
	      [
	         36.230212,
	         50.006483
	      ],
	      [
	         36.230524,
	         50.006310
	      ],
	      [
	         36.230870,
	         50.005996
	      ],
	      [
	         36.231468,
	         50.005533
	      ],
	      [
	         36.231844,
	         50.005242
	      ],
	      [
	         36.233600,
	         50.006721
	      ],
	      [
	         36.234662,
	         50.006347
	      ],
	      [
	         36.234619,
	         50.006283
	      ],
	      [
	         36.234256,
	         50.005804
	      ]
	   ],
	   "properties":{
	      "distance":"0.620647",
	      "description":"To enable simple instructions add: 'instructions=1' as parameter to the URL",
	      "traveltime":"108"
	   }
	}