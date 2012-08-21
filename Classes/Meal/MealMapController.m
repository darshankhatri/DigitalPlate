//
//  MealMapController.m
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MealMapController.h"
#import "MealAnnotation.h"
#import "RestaurantViewController.h"

@implementation MealMapController

@synthesize mapView;
@synthesize userMealInfo;

#pragma mark -
#pragma mark Memory Management


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    self.mapView = nil;
    self.userMealInfo = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    
    self.navigationItem.title = @"Location";
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    //set left navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 55, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarBtnBackNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarBtnBackPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@" Back" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftItem];
	[leftItem release];
    
    if([self.userMealInfo.restaurant.latitude intValue] > 90 || [self.userMealInfo.restaurant.latitude intValue] < -90 || [self.userMealInfo.restaurant.longitude intValue] > 180 || [self.userMealInfo.restaurant.latitude intValue] < -180) {
        
        UIAlertView *alerMessage = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Invalid Map Location!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerMessage show];
        [alerMessage release];

    }
    else {
        MealAnnotation *annotation = [[MealAnnotation alloc] initWithUserMealInformation:self.userMealInfo];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(annotation.coordinate, 10000, 10000)];
        [self.mapView addAnnotation:annotation];
        [annotation release];    
    }
    

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Bar button actions

-(void)backButtonPressed:(id)sender {    
    //    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}


#pragma mark -
#pragma mark Map actions

-(void)viewRestaurantInfo:(id)sender {
    RestaurantViewController *_restaurantController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
    _restaurantController.userMealInfo = self.userMealInfo;
    [self.navigationController pushViewController:_restaurantController animated:TRUE];
    [_restaurantController release];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
    
    MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                           initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
    customPinView.pinColor = MKPinAnnotationColorGreen;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self
                    action:@selector(viewRestaurantInfo:)
          forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    return customPinView;//[kml viewForAnnotation:annotation];
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
