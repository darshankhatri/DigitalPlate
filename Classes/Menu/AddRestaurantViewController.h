//
//  AddRestaurantViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import <CoreLocation/CoreLocation.h>
#import "DAL.h"


@interface AddRestaurantViewController : UIViewController<UITextViewDelegate,CLLocationManagerDelegate>
{
    UILabel *lblRestaurant;
    UILabel *lblAddress;
    UILabel *lblWeb;
    UILabel *lblEmail;
    
    UIButton *btnRestaurant;
    UIButton *btnAddress;
    UIButton *btnWeb;
    UIButton *btnEmail;
    
    UITextView *txtRestaurant;
    UITextView *txtAddress;
    UITextView *txtWebsite;
    UITextView *txtEmail;
    
    Restaurant *restaurant;
    
    CLLocationManager *locationManager;    
    CLLocation *bestEffortAtLocation;
    NSMutableArray *locationMeasurements; 
    DAL *database;
}

@property(nonatomic,retain) IBOutlet UILabel *lblRestaurant;
@property(nonatomic,retain) IBOutlet UILabel *lblAddress;
@property(nonatomic,retain) IBOutlet UILabel *lblWeb;
@property(nonatomic,retain) IBOutlet UILabel *lblEmail;

@property(nonatomic,retain) IBOutlet UIButton *btnRestaurant;
@property(nonatomic,retain) IBOutlet UIButton *btnAddress;
@property(nonatomic,retain) IBOutlet UIButton *btnWeb;
@property(nonatomic,retain) IBOutlet UIButton *btnEmail;

@property(nonatomic,retain) UITextView *txtRestaurant;
@property(nonatomic,retain) UITextView *txtAddress;
@property(nonatomic,retain) UITextView *txtWebsite;
@property(nonatomic,retain) UITextView *txtEmail;

@property(nonatomic,retain) Restaurant *restaurant;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;

-(IBAction)updateRestaurantName:(id)sender;
-(IBAction)updateAddress:(id)sender;
-(IBAction)updateEmail:(id)sender;
-(IBAction)updateWebsite:(id)sender;

- (void)stopUpdatingLocation:(NSString *)state;

@end
