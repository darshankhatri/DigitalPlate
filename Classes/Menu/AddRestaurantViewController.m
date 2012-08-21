//
//  AddRestaurantViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "AddRestaurantViewController.h"
#import "JSON.h"


@implementation AddRestaurantViewController

#define ALERT_RESTAURANT    1
#define ALERT_ADDRESS       2
#define ALERT_WEBSITE       3
#define ALERT_EMAIL         4

@synthesize lblRestaurant;
@synthesize lblAddress;
@synthesize lblWeb;
@synthesize lblEmail;
@synthesize btnRestaurant;
@synthesize btnAddress;
@synthesize btnWeb;
@synthesize btnEmail;

@synthesize txtRestaurant;
@synthesize txtAddress;
@synthesize txtWebsite;
@synthesize txtEmail;

@synthesize restaurant;

@synthesize locationManager;
@synthesize bestEffortAtLocation;
@synthesize locationMeasurements;

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
    self.lblRestaurant = nil;
    self.lblAddress = nil;
    self.lblWeb = nil;
    self.lblEmail = nil;
    self.btnRestaurant = nil;
    self.btnAddress = nil;
    self.btnWeb = nil;
    self.btnEmail = nil;
    
    self.txtRestaurant = nil;
    self.txtAddress = nil;
    self.txtWebsite = nil;
    self.txtEmail = nil;
    
    self.restaurant = nil;
    
    [locationManager release];
    [bestEffortAtLocation release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    database = [[DAL alloc] init];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    //set right navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(saveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem];
	[rightItem release];
    
    
    //set left navigation item
    button = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    if(self.restaurant != nil) {
        [self.lblRestaurant setText:self.restaurant.resturantName];
        [self.lblAddress setText:self.restaurant.address];
        [self.lblEmail setText:self.restaurant.email];
        [self.lblWeb setText:self.restaurant.website];        
    }
    else {
        Restaurant *_restaurant = [[Restaurant alloc] init];
        self.restaurant = _restaurant;
        [_restaurant release];
        
        self.locationMeasurements = [NSMutableArray array];
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [locationManager startUpdatingLocation];
        [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:10.0];
    }


}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Bar Button Actions

-(void)saveClicked:(id)sender {
    
    NSString *message = nil;
    BOOL validated = TRUE;
    
    if(self.restaurant.resturantName == nil || [self.restaurant.resturantName isEqualToString:@""]) {
        message = @"Please add the Restaurant name.";
        validated = FALSE;
    }
    else if(self.restaurant.address == nil || [self.restaurant.address isEqualToString:@""]) {
        message = @"Please add address for Restaurant.";
        validated = FALSE;
    }
    
    if(validated) {
        [NSThread detachNewThreadSelector:@selector(doSaveRestaurant) toTarget:self withObject:nil]; 
    }
    else {
        UIAlertView *alerMessage = [[UIAlertView alloc] initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerMessage show];
        [alerMessage release];
    }
}


-(void)backButtonPressed:(id)sender {    
    [self.navigationController popViewControllerAnimated:TRUE];
}


#pragma mark -
#pragma mark Server Communication

- (void)doSaveRestaurant {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 
}

-(void)prepareRequestDirectory {
    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(![delegate checkInternetConnectivity])
    {
        // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if(self.restaurant.restaurantID == nil) {
             NSString *query = [NSString stringWithFormat:@"INSERT INTO restaurants(Restaurant_Name,Restaurant_ID,Address, Lat, Long, Website_Detail, Email, flag, Number_of_favourite_meal) VALUES('%@','%@','%@', '%@', '%@', '%@' , '%@', '0', '%@');", restaurant.resturantName, restaurant.restaurantID, restaurant.address, restaurant.latitude, restaurant.longitude, restaurant.website, restaurant.email, restaurant.favoriteMeals];
            [database execureScalar:query];
        }
        return;
    }
    // Prepare Meal Dictionary.
    NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
    NSMutableArray *message = nil;
    NSString *strMessage = nil;
    
    //  In case of adding new restaurant
    if(self.restaurant.restaurantID == nil) {
        [dt setObject:self.restaurant.resturantName forKey:@"Restaurant_Name"];    
        [dt setObject:self.restaurant.address forKey:@"Address"];    
        [dt setObject:self.restaurant.latitude forKey:@"Lat"];            
        [dt setObject:self.restaurant.longitude forKey:@"Long"];            
        [dt setObject:self.restaurant.website forKey:@"Website_Detail"];            
        [dt setObject:self.restaurant.email forKey:@"Email"];  
        
        //Prepare Request
        message = [RequestHandler addNewRestaurant:dt]; 
        for(NSDictionary *dict in message) {
            strMessage = [dict valueForKey:@"Status"];
        }
    }
    //  In case of editing restaurant
    else {
        [dt setObject:self.restaurant.restaurantID forKey:@"Restaurant_ID"];     
        [dt setObject:self.restaurant.resturantName forKey:@"Restaurant_Name"];    
        [dt setObject:self.restaurant.address forKey:@"Address"];    
        [dt setObject:self.restaurant.latitude forKey:@"Lat"];            
        [dt setObject:self.restaurant.longitude forKey:@"Long"];            
        [dt setObject:self.restaurant.website forKey:@"Website_Detail"];            
        [dt setObject:self.restaurant.email forKey:@"Email"];                            
        
        //Prepare Request
        message = [RequestHandler editRestaurant:dt]; 
        for(NSDictionary *dict in message) {
            strMessage = [dict valueForKey:@"Status"];
        }
    }
    
    NSLog(@"%@",strMessage);
    
    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertError show];
    [alertError release];
    
    [delegate stopActivityIndicator];
        
}


#pragma mark -
#pragma mark IB Outlet Actions

-(IBAction)updateRestaurantName:(id)sender {
    
    if(!self.txtRestaurant) {
        
        CGRect frame = CGRectMake(14, 45, 255, 65);
        UITextView *textField = [[UITextView alloc] initWithFrame:frame];
        [textField.layer setCornerRadius:5.0];
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = fontHelvetica14;
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.keyboardType = UIKeyboardTypeEmailAddress; // use the default type input method (entire keyboard)
        textField.returnKeyType = UIReturnKeyDone;
        self.txtRestaurant = textField;
        [textField release];
        
        self.txtRestaurant.delegate = self;
    }
    
    [self.txtRestaurant setText:self.lblRestaurant.text];
    //self.userMealInfo.mealInfo.meal_Name = self.txtMeal.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Restaurant Name" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert addSubview:self.txtRestaurant];
    [alert setTag:ALERT_RESTAURANT]; 
    [alert show];    
    [alert release];
}

-(IBAction)updateLocation:(id)sender {
    
}

-(IBAction)updateAddress:(id)sender {
    
    if(!self.txtAddress) {
        
        CGRect frame = CGRectMake(14, 45, 255, 65);
        UITextView *textField = [[UITextView alloc] initWithFrame:frame];
        [textField.layer setCornerRadius:5.0];
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = fontHelvetica14;
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.keyboardType = UIKeyboardTypeEmailAddress; // use the default type input method (entire keyboard)
        textField.returnKeyType = UIReturnKeyDone;
        self.txtAddress = textField;
        [textField release];
        
        self.txtAddress.delegate = self;
    }
    
    [self.txtAddress setText:self.lblAddress.text];
    //self.userMealInfo.mealInfo.meal_Name = self.txtMeal.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Address" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert addSubview:self.txtAddress];
    [alert setTag:ALERT_ADDRESS]; 
    [alert show];    
    [alert release];
}

-(IBAction)updateEmail:(id)sender {
    
    if(!self.txtEmail) {
        
        CGRect frame = CGRectMake(14, 45, 255, 65);
        UITextView *textField = [[UITextView alloc] initWithFrame:frame];
        [textField.layer setCornerRadius:5.0];
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = fontHelvetica14;
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.keyboardType = UIKeyboardTypeEmailAddress; // use the default type input method (entire keyboard)
        textField.returnKeyType = UIReturnKeyDone;
        self.txtEmail = textField;
        [textField release];
        
        self.txtEmail.delegate = self;
    }
    
    [self.txtEmail setText:self.lblEmail.text];
    //self.userMealInfo.mealInfo.meal_Name = self.txtMeal.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert addSubview:self.txtEmail];
    [alert setTag:ALERT_EMAIL]; 
    [alert show];    
    [alert release];
}

-(IBAction)updateWebsite:(id)sender {
    
    if(!self.txtWebsite) {
        
        CGRect frame = CGRectMake(14, 45, 255, 65);
        UITextView *textField = [[UITextView alloc] initWithFrame:frame];
        [textField.layer setCornerRadius:5.0];
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = fontHelvetica14;
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.keyboardType = UIKeyboardTypeEmailAddress; // use the default type input method (entire keyboard)
        textField.returnKeyType = UIReturnKeyDone;
        self.txtWebsite = textField;
        [textField release];
        
        self.txtWebsite.delegate = self;
    }
    
    [self.txtWebsite setText:self.lblWeb.text];
    //self.userMealInfo.mealInfo.meal_Name = self.txtMeal.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Website" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert addSubview:self.txtWebsite];
    [alert setTag:ALERT_WEBSITE]; 
    [alert show];    
    [alert release];
}

#pragma mark -
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView tag] == ALERT_RESTAURANT && buttonIndex == 1) {
        [self.lblRestaurant setText:self.txtRestaurant.text];
        self.restaurant.resturantName = self.txtRestaurant.text;
    }
    else if([alertView tag] == ALERT_ADDRESS && buttonIndex == 1) {
        [self.lblAddress setText:self.txtAddress.text];
        self.restaurant.address = self.txtAddress.text;        
    }
    else if([alertView tag] == ALERT_EMAIL && buttonIndex == 1) {
        [self.lblEmail setText:self.txtEmail.text];
        self.restaurant.email = self.txtEmail.text;        
    }
    else if([alertView tag] == ALERT_WEBSITE && buttonIndex == 1) {
        [self.lblWeb setText:self.txtWebsite.text];
        self.restaurant.website = self.txtWebsite.text;        
    }
}

#pragma mark -
#pragma mark Location Delegates

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Location could not be determined" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert release];
    [alert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive
    [locationMeasurements addObject:newLocation];
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
}


- (void)stopUpdatingLocation:(NSString *)state {
    NSLog(@"Latitude:");
    
    if([locationMeasurements count]>0) {
        CLLocation *location = [locationMeasurements objectAtIndex:[locationMeasurements count]-1];        
        
        NSString *lat = [[NSString alloc] initWithFormat:@"%g", location.coordinate.latitude];
        NSLog(@"Latitude: %@", lat);
        
        NSString *lng = [[NSString alloc] initWithFormat:@"%g", location.coordinate.longitude];
        NSLog(@"Longitude: %@", lng);
        
        //if(self.restaurant.restaurantID == nil) {
            self.restaurant.latitude = lat;
            self.restaurant.longitude = lng;
        //}
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Location could not be determined" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert release];
        [alert show];
    }
    
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
