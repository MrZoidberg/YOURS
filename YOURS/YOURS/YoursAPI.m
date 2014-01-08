//
//  YoursAPI.m
//  YOURS
//
//  Created by Mikhail Merkulov on 07.01.14.
//  Copyright (c) 2014 ZoidSoft. All rights reserved.
//

#import "YoursAPI.h"
#import <AFNetworking/AFNetworking.h>

#define kYoursAPIBaseUrl @"http://www.yournavigation.org/api/1.0/gosmore.php"
#define kYoursFairUseDelayInSec 1

typedef NS_ENUM(NSInteger, YoursResponseFormat) {
    YoursResponseFormatKML,
    YoursResponseFormatGeoJSON
};

@interface YoursAPI() {
    YoursResponseFormat _responseFormat;
    dispatch_queue_t _queue;
}

@end

@implementation YoursAPI

@synthesize transportType = _transportType;
@synthesize selectFastestsRoute = _selectFastestsRoute;
@synthesize includeRouteGeometry = _includeRouteGeometry;
@synthesize includeInstructions = _includeInstructions;
@synthesize responseLanguage = _responseLanguage;
@synthesize clientInfo = _clientInfo;
@synthesize enforceFairUsePolicy = _enforceFairUsePolicy;


- (instancetype)init
{
    if (self = [super init]) {
        _responseFormat = YoursResponseFormatGeoJSON;
        _transportType = YoursTransportTypeMotorcar;
        _selectFastestsRoute = YES;
        _includeRouteGeometry = YES;
        _includeInstructions = NO;
        _responseLanguage = @"en";
        _enforceFairUsePolicy = YES;
        
        
        _queue = dispatch_queue_create("com.zoidsoft.YoursQueue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (NSString *)transportTypeString
{
    switch (_transportType) {
        case YoursTransportTypeMotorcar:
            return @"motorcar";
        case YoursTransportTypeBicycle:
            return @"bicycle";
        case YoursTransportTypeFoot:
            return @"foot";
        default:
            return nil;
    }
}

- (NSString *)mapLayer
{
    if (_transportType != YoursTransportTypeBicycle)
        return @"mapnik";
    else
        return @"cn";
}

- (void)internalCalc:(CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D)toLocation
             success:(void (^)(NSDictionary *response))success
             failure:(void (^)(NSError *error))failure
{
    NSDictionary *params = @{@"flat": @(fromLocation.latitude), @"flon": @(fromLocation.longitude), @"tlat": @(toLocation.latitude), @"tlon": @(toLocation.longitude),
                             @"v": [self transportTypeString], @"fast": @(_selectFastestsRoute), @"layer" : [self mapLayer], @"geometry": @(_includeRouteGeometry),
                             @"instructions" : @(_includeInstructions), @"lang" : _responseLanguage, @"format": @"geojson"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:_clientInfo forHTTPHeaderField:@"X-Yours-client"];
    
    [manager GET:kYoursAPIBaseUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *responseDict = responseObject;
        success(responseDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        failure(error);
    }];

}

- (void)calcRouteFromLocation:(CLLocationCoordinate2D)fromLocation toLocation:(CLLocationCoordinate2D)toLocation
                      success:(void (^)(NSDictionary *response))success
                      failure:(void (^)(NSError *error))failure
{
    if (_clientInfo == nil) {
        failure([NSError errorWithDomain:@"YoursAPIDomain" code:100 userInfo:@{NSLocalizedDescriptionKey : @"Client info string is not provided."}]);
        return;
    }
    
    if (_enforceFairUsePolicy){
        dispatch_async(_queue, ^{
                [self internalCalc:fromLocation toLocation:toLocation success:success failure:failure];
            });
    } else {
        [self internalCalc:fromLocation toLocation:toLocation success:success failure:failure];
    }
}

@end
