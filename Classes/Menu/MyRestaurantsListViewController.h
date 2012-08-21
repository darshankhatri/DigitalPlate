//
//  MyRestaurantsListViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DAL.h"

@interface MyRestaurantsListViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate>
{
    UITextField *searchTextField;
    UITableView *restaurantsTable;
    
    CLLocationManager *locationManager;    
    CLLocation *bestEffortAtLocation;
    NSMutableArray *locationMeasurements;    
    NSMutableArray *filterredRestaurant;
    
    NSArray *restaurantList;
    int type;
    BOOL searchBarSelected;
    
    DAL *database;
}

@property(nonatomic,retain) IBOutlet UITextField *searchTextField;
@property(nonatomic,retain) IBOutlet UITableView *restaurantsTable;

@property(nonatomic,retain) NSArray *restaurantList;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) NSMutableArray *filterredRestaurant;

@property(nonatomic, readwrite) int type;

- (void)prepareRecentMealList;
- (void)stopUpdatingLocation:(NSString *)state;

- (IBAction)searchUsingContentsOfTextField:(id)sender;

@end
