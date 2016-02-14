//
//  WeatherDetailViewController.m
//  PhunwareWeather
//
//  Created by Jason Fullen on 2/13/16.
//  Copyright © 2016. All rights reserved.
//

#import "WeatherDetailViewController.h"
#import "Weather.h"
#import "MBProgressHUD.h"

@interface WeatherDetailViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, WeatherDelegate>

@property (nonatomic, strong) Weather *weather;
@property (nonatomic, strong) NSDictionary *myWeatherData;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic) BOOL didErrorOccur;

-(void)showProgressViewAndQueryWeather;
-(void)showErrorAlert: (NSError *)error;

@end

@implementation WeatherDetailViewController

@synthesize zipCodeTextField = _zipCodeTextField;
@synthesize tempTableView = _tempTableView;
@synthesize zipCodes = _zipCodes;
@synthesize selectedZipCode = _selectedZipCode;
@synthesize weather = _weather;
@synthesize myWeatherData = _myWeatherData;
@synthesize hud = _hud;
@synthesize didErrorOccur = _didErrorOccur;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.zipCodeTextField.text = self.selectedZipCode;
    self.weather = [[Weather alloc] init];
    self.weather.weatherDelegate = self;
    self.myWeatherData = nil;
    self.didErrorOccur = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    if ([self.selectedZipCode isEqualToString: @""]) {
        [self.zipCodeTextField becomeFirstResponder];
    } else {
        [self showProgressViewAndQueryWeather];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    if (self.didErrorOccur || ![self.zipCodes containsObject: self.selectedZipCode]) {
        NSLog(@"Adding %@ to zip codes array for storage", self.selectedZipCode);
        [self.zipCodes addObject: self.selectedZipCode];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.myWeatherData allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherData" forIndexPath:indexPath];
    cell.textLabel.text = [[self.myWeatherData allKeys] objectAtIndex: [indexPath row]];
    cell.detailTextLabel.text = [self.myWeatherData objectForKey: [[self.myWeatherData allKeys] objectAtIndex: [indexPath row]]];
    return cell;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.selectedZipCode = self.zipCodeTextField.text;
    [self showProgressViewAndQueryWeather];
    return [self.zipCodeTextField resignFirstResponder];
}

#pragma mark - WeatherDelegate

- (void)currentWeatherData:(NSDictionary *)weatherData withError: (NSError *)error {
    [self.hud hide:YES];
    
    if (error) {
        [self showErrorAlert: error];
    } else {
        if (weatherData) {
            self.myWeatherData = [weatherData copy];
            [self.tempTableView reloadData];
        }
    }
}

-(void)showProgressViewAndQueryWeather {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading";
    
    [self.weather getCurrentWeatherByLocationData: self.selectedZipCode];
}

-(void)showErrorAlert: (NSError *)error {
    self.didErrorOccur = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to retrieve weather data." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self.navigationController popToRootViewControllerAnimated: YES];
    }];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
