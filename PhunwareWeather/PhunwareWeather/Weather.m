//
//  Weather.m
//
//  Created by Jason Fullen on 2/13/16.
//  Copyright © 2016. All rights reserved.
//

#import "Weather.h"
#import "OWMWeatherAPI.h"
#import "CoordinateConverter.h"

@interface Weather()

@property (nonatomic, strong) OWMWeatherAPI *weather;
@property (nonatomic, strong) CoordinateConverter *coordinateConverter;

-(NSDictionary *)convertWeatherDataToDictionary: (NSDictionary *)currentWeatheDictionary;

@end

@implementation Weather

@synthesize weatherDelegate = _weatherDelegate;
@synthesize weather = _weather;
@synthesize coordinateConverter = _coordinateConverter;

- (id)init {
    if (self = [super init]) {
        self.weather = [[OWMWeatherAPI alloc] initWithAPIKey:@"3ed5d4d600209308f015a69c711ca3f2"];
        [self.weather setTemperatureFormat:kOWMTempFahrenheit];
        
        self.coordinateConverter = [[CoordinateConverter alloc] init];
    }
    return self;
}

-(void)getCurrentWeatherByLocationData: (NSString *)locationData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.coordinateConverter convertLoactionStringToLatitudeLongitude:locationData withCallback:^(CLLocationCoordinate2D coordinate, NSError *error) {
            if (error) {
                NSLog(@"Error trying to convert location string to lat/lon");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.weatherDelegate currentWeatherData:nil withError:error];
                });
            } else {
                [self.weather currentWeatherByCoordinate:coordinate withCallback:^(NSError *error, NSDictionary *result) {
                    if (error) {
                        // handle the error
                        NSLog(@"OWMWeather currentWeatherByLocationData() returned an error.");
                        [self.weatherDelegate currentWeatherData:nil withError:error];
                        return;
                    }
                    
                    // The data is ready
                    NSLog(@"OWMWeather currentWeatherByCoordinate() successful.");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.weatherDelegate currentWeatherData:[self convertWeatherDataToDictionary:result] withError:error];
                    });
                }];
                
            }
        }];
    });
}

-(void)getCurrentWeatherByCityName: (NSString *)cityName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.weather currentWeatherByCityName:cityName withCallback:^(NSError *error, NSDictionary *result) {
            if (error) {
                // handle the error
                NSLog(@"OWMWeather currentWeatherByCityName() returned an error.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.weatherDelegate currentWeatherData:nil withError:error];
                });
                return;
            }
            
            // The data is ready
            NSLog(@"OWMWeather currentWeatherByCityName() successful.");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.weatherDelegate currentWeatherData:[self convertWeatherDataToDictionary:result] withError:error];
            });
        }];
    });
}

-(void)getCurrentWeatherByCoordinate: (CLLocationCoordinate2D)coordinate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.weather currentWeatherByCoordinate:coordinate withCallback:^(NSError *error, NSDictionary *result) {
            if (error) {
                // handle the error
                NSLog(@"OWMWeather currentWeatherByCoordinate() returned an error.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.weatherDelegate currentWeatherData:nil withError:error];
                });
                return;
            }
            
            // The data is ready
            NSLog(@"OWMWeather currentWeatherByCoordinate() successful.");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.weatherDelegate currentWeatherData:[self convertWeatherDataToDictionary:result] withError:error];
            });
        }];
    });
}

-(void)getCurrentWeatherByCityID: (NSString *)cityID {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.weather currentWeatherByCityId:cityID withCallback:^(NSError *error, NSDictionary *result) {
            if (error) {
                // handle the error
                NSLog(@"OWMWeather currentWeatherByCityId() returned an error.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.weatherDelegate currentWeatherData:nil withError:error];
                });
                return;
            }
            
            // The data is ready
            NSLog(@"OWMWeather currentWeatherByCityId() successful.");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.weatherDelegate currentWeatherData:[self convertWeatherDataToDictionary:result] withError:error];
            });
        }];
    });
}

-(NSDictionary *)convertWeatherDataToDictionary: (NSDictionary *)currentWeatheDictionary {
    NSMutableDictionary *weather = [[NSMutableDictionary alloc] init];
    
    NSString *cityName = currentWeatheDictionary[@"name"];
    [weather setObject: cityName forKey: @"CityName"];
    
    NSNumber *currentTemp = currentWeatheDictionary[@"main"][@"temp"];
    [weather setObject: [currentTemp stringValue] forKey: @"CurrentTemp"];
    
    NSNumber *lat = currentWeatheDictionary[@"coord"][@"lat"];
    [weather setObject: [lat stringValue] forKey: @"Latitude"];
    
    NSNumber *lon = currentWeatheDictionary[@"coord"][@"lon"];
    [weather setObject: [lon stringValue] forKey: @"Longitude"];
    
    return [NSDictionary dictionaryWithDictionary: weather];
}

@end
