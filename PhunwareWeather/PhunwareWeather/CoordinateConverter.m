//
//  CoordinateConverter.m
//  PhunwareWeather
//
//  Created by Jason Fullen on 2/14/16.
//  Copyright © 2016. All rights reserved.
//

#import "CoordinateConverter.h"

@interface CoordinateConverter()

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation CoordinateConverter

@synthesize geocoder = _geocoder;

-(id)init {
    self = [super init];
    
    if (self) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    return self;
}

-(void)convertLoactionStringToLatitudeLongitude: (NSString *)locationData withCallback: (void(^)(CLLocationCoordinate2D coordinate, NSError *error))callback {
    [self.geocoder geocodeAddressString:locationData completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        CLLocation *location = placemark.location;
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        callback(coordinate, error);
    }];
}

@end
