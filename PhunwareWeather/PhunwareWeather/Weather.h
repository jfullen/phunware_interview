//
//  Weather.h
//
//  Created by Jason Fullen on 2/13/16.
//  Copyright © 2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherDelegate.h"

@interface Weather : NSObject

@property (nonatomic, weak) id<WeatherDelegate> weatherDelegate;

-(void)getCurrentWeatherByLocationData: (NSString *)locationData;
-(void)getCurrentWeatherByCityName: (NSString *)cityName;
-(void)getCurrentWeatherByCoordinate: (CLLocationCoordinate2D)coordinate;
-(void)getCurrentWeatherByCityID: (NSString *)cityID;

@end
