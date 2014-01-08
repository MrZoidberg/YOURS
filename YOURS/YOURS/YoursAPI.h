//
//  YoursAPI.h
//  YOURS
//
//  Created by Mikhail Merkulov on 07.01.14.
//  Copyright (c) 2014 ZoidSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, YoursTransportType) {
    YoursTransportTypeMotorcar,
    YoursTransportTypeBicycle,
    YoursTransportTypeFoot
};

@interface YoursAPI : NSObject

/**
 Transportation type. 'YoursTransportTypeMotorcar' is default.
 
 @see YoursTransportType
*/
@property (nonatomic) YoursTransportType transportType;

/**
 Should the routing engine select the fastest route. Otherwise it will select the shorties route. 'YES' by default.
 */
@property (nonatomic) BOOL selectFastestsRoute;

/**
 Include route geometry into the result. 'YES' by default.
 */
@property (nonatomic) BOOL includeRouteGeometry;

/**
 Include routing instruction into the result. 'NO' by default.
 
 @see 'responseLanguage' for the language of the instructions.
 */
@property (nonatomic) BOOL includeInstructions;

/**
 Response language. 'en' by default
 
 @see The list of available languages in YOURS API documentation: http://wiki.openstreetmap.org/wiki/YOURS#API_documentation
 */
@property (nonatomic, strong) NSString *responseLanguage;

/**
 Client application information (e.g. website). Used by YOURS to track requests.
 
 @warning `clientInfo` must not be `nil`.
 */
@property (nonatomic, strong) NSString *clientInfo;

/**
 Should the YOURS API fair use policy be enforced. 'YES' by default.
 */
@property (nonatomic) BOOL enforceFairUsePolicy;

/**
 Shared instance of the YoursAPI class.
 */
+ (instancetype)sharedInstance;

/**
 Runs the route calculation request
 
 @param fromLocation Starting location.
 @param toLocation End location.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: the response dictionary.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one arguments: the error describing the network or parsing error that occurred.
 */
- (void)calcRouteFromLocation:(CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D)toLocation
                      success:(void (^)(NSDictionary *response))success
                      failure:(void (^)(NSError *error))failure;


@end
