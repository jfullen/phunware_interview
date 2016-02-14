//
//  WeatherDelegate.h
//  PhunwareWeather
//
//  Created by Jason Fullen on 2/14/16.
//  Copyright © 2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherDelegate <NSObject>

@required
-(void)currentWeatherData:(NSDictionary *)weatherData withError: (NSError *)error;

@end
