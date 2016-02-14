//
//  WeatherDetailViewController.h
//  PhunwareWeather
//
//  Created by Jason Fullen on 2/13/16.
//  Copyright © 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *zipCodeTextField;
@property (nonatomic, weak) IBOutlet UITableView *tempTableView;
@property (nonatomic, strong) NSMutableArray *zipCodes;
@property (nonatomic, strong) NSString *selectedZipCode;

@end
