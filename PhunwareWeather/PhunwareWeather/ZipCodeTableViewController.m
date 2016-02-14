//
//  ZipCodeTableViewController.m
//  PhunwareWeather
//
//  Created by Jason Fullen on 2/13/16.
//  Copyright © 2016. All rights reserved.
//

#import "ZipCodeTableViewController.h"
#import "WeatherDetailViewController.h"

@interface ZipCodeTableViewController ()

@property (nonatomic) NSInteger selectedIndex;

- (NSMutableArray *)getStoredZipCodes;

@end

@implementation ZipCodeTableViewController

@synthesize selectedIndex = _selectedIndex;
@synthesize zipCodes = _zipCodes;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    self.selectedIndex = -1;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zipCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZipCode" forIndexPath:indexPath];
    cell.textLabel.text = [self.zipCodes objectAtIndex: [indexPath row]];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.zipCodes removeObjectAtIndex: [indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self.tableView setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = [indexPath row];
    [self performSegueWithIdentifier:@"WeatherDetail" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"WeatherDetail"]) {
        WeatherDetailViewController *weatherDetailViewController = (WeatherDetailViewController *)[segue destinationViewController];
        weatherDetailViewController.zipCodes = self.zipCodes;
        if (self.selectedIndex == -1) {
            weatherDetailViewController.selectedZipCode = @"";
        } else {
            weatherDetailViewController.selectedZipCode = [self.zipCodes objectAtIndex: self.selectedIndex];
        }
        NSLog(@"Handling WeatherDetail segue");
    }
}

@end
