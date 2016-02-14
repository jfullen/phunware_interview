//
//  CoordinateConverter.h
//  PhunwareWeather
//
//  Created by Jason Fullen on 2/14/16.
//  Copyright © 2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CoordinateConverter : NSObject

-(void)convertLoactionStringToLatitudeLongitude: (NSString *)locationData withCallback: (void(^)(CLLocationCoordinate2D coordinate, NSError *error))callback;

@end
