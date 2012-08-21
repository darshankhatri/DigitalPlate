//
//  MyRestaurantsListViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MyRestaurantsListViewController.h"
#import "RestaurantCell.h"
#import "RestaurantsMealListController.h"
#import "AddRestaurantViewController.h"
#import "Restaurant.h"
#import "UserMealInfo.h"
#import "MealMapController.h"


@implementation MyRestaurantsListViewController

@synthesize restaurantList;
@synthesize type;

@synthesize searchTextField;
@synthesize restaurantsTable;

@synthesize locationManager;
@synthesize bestEffortAtLocation;
@synthesize locationMeasurements;
@synthesize filterredRestaurant;

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

-(void)dealloc {
    self.restaurantsTable.dataSource = nil;
    self.restaurantsTable.delegate = nil;
    [locationManager release];
    [bestEffortAtLocation release];
    [searchTextField release];
    [restaurantsTable release];
    [restaurantList release];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
        
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    self.locationMeasurements = [NSMutableArray array];

    //set right navigation item
    
    switch (self.type) {
        case TYPE_MY_RESTAURANT:
            self.navigationItem.title = @"My Restaurant";
            break;
            
        case TYPE_NEARBY_RESTAURANT:
            self.navigationItem.title = @"Nearby Restaurant";
            break;
            
        case TYPE_TOP_RESTAURANT:
            self.navigationItem.title = @"Top Restaurant";            
            break;            
        default:
            break;
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
        
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 55, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Add+" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];    
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem];
	[rightItem release];

    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    self.filterredRestaurant = [NSMutableArray array];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [self prepareRecentMealList];
    [super viewDidAppear:TRUE];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark Server Communication


-(void)prepareRecentMealList {
    
    DigitalPlateAppDelegate *appDel = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dt1 = [[NSMutableDictionary alloc]init];
    [dt1 setObject:appDel.userInfo.UserID forKey:@"User_ID"];  
    
    if(![appDel checkInternetConnectivity])
    {
        switch (self.type)
        {
            case TYPE_MY_RESTAURANT:

                database = [[DAL alloc] init];
                NSMutableArray *returnArray = [[NSMutableArray alloc] init];
                NSString *query =[NSString stringWithFormat:@"SELECT * FROM myRestaurants"];
                NSDictionary *databaseValue = [database executeDataSet:query];
                
                NSArray *tempArray = [databaseValue allKeys];
                for (int i = 1; i <= [tempArray count]; i++) {
                    
                    NSString *databaseKey = [NSString stringWithFormat:@"Table %d",i];
                    NSMutableDictionary *values =  [databaseValue objectForKey:databaseKey];
                    NSMutableDictionary *Restaurant_OBJ = [[NSMutableDictionary alloc] init];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Address"] forKey:@"Address"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"City"] forKey:@"City"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Country"] forKey:@"Country"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Email"] forKey:@"Email"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Lat"] forKey:@"Lat"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Long"] forKey:@"Long"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Number_of_favourite_meal"] forKey:@"Number_of_favourite_meal"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Pincode"] forKey:@"Pincode"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Restaurant_ID"] forKey:@"Restaurant_ID"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Restaurant_Name"] forKey:@"Restaurant_Name"];
                    [Restaurant_OBJ setValue:[values valueForKey:@"Website_Detail"] forKey:@"Website_Detail"];  
                    
                    Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:Restaurant_OBJ];
                    [returnArray addObject:restaurant];
                    NSLog(@"%d      %@", i , returnArray);
                    
                    
                }
                self.restaurantList = returnArray;
                [self.restaurantList  retain];
                [appDel stopActivityIndicator]; 
                
                NSLog(@"self.restaurantList :%@",[[self.restaurantList objectAtIndex:0] description]);
                
                if([self.restaurantList count] > 0 && [[self.restaurantList objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_NORESTAURANT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                else {
                    [restaurantsTable reloadData];        
                }
                [returnArray release];
                
                break;
            default:
                break;
        }
        return;
        
    }

    switch (self.type) {
        case TYPE_MY_RESTAURANT:
            self.restaurantList = [RequestHandler getUserRestaurantList:dt1];
            [appDel stopActivityIndicator]; 
            
            NSLog(@"self.restaurantList :%@",[[self.restaurantList objectAtIndex:0] description]);
                        
            if([self.restaurantList count] > 0 && [[self.restaurantList objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_NORESTAURANT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else {
                [restaurantsTable reloadData];        
            }
            
            break;
            
        case TYPE_NEARBY_RESTAURANT:
            self.locationManager = [[[CLLocationManager alloc] init] autorelease];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            [locationManager startUpdatingLocation];
            [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:10.0];
            //self.restaurantList = [RequestHandler getNearByRestaurantList:dt1];            
            break;
            
        case TYPE_TOP_RESTAURANT:
            self.restaurantList = [RequestHandler getTopRestaurantList:dt1];            
            [appDel stopActivityIndicator];            
            
            if([self.restaurantList count] > 0 && [[self.restaurantList objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_NORESTAURANT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else {
                [restaurantsTable reloadData];        
            }
            break;            
            
        default:
            break;
    }
    
    [dt1 release];
}

-(void)backButtonPressed:(id)sender {    
    //DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

-(void)addClicked:(id)sender {
    AddRestaurantViewController *controller = [[AddRestaurantViewController alloc]initWithNibName:@"AddRestaurantViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}



#pragma -
#pragma mark search methods

- (IBAction)searchUsingContentsOfTextField:(id)sender {
    
    searchBarSelected = TRUE;    
    [self.filterredRestaurant removeAllObjects];
    NSString *searchString= ((UITextField *)sender).text;
    
    for (Restaurant *restaurant in self.restaurantList) {
            
        NSString *str = [NSString stringWithFormat:@"%@",restaurant.resturantName];
        if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound) {
            [self.filterredRestaurant addObject:restaurant];
        }
    }
    
    if ([((UITextField *)sender).text length]==0) {
        searchBarSelected = FALSE;
    }
    [self.restaurantsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    searchBarSelected = FALSE;
    return TRUE;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    searchBarSelected = FALSE;
    [self.restaurantsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];     
    [textField resignFirstResponder];
    return TRUE;
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int rowheight;
    if (indexPath.section==0) {
        rowheight = 80;
    }
	return rowheight;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    if(searchBarSelected) {
        return [self.filterredRestaurant count];
    }
    else {
        return [restaurantList count];	        
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RestaurantCell";
    static NSString *CellNib = @"RestaurantCell";

    RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (RestaurantCell *)[nib objectAtIndex:0];
        [cell.mapViewButton addTarget:self action:@selector(openMap:) forControlEvents:UIControlEventTouchUpInside];        
        
    }
    Restaurant *restaurant = nil;
    if(searchBarSelected) {
        restaurant = [self.filterredRestaurant objectAtIndex:indexPath.row];
    }
    else {
        restaurant = [self.restaurantList objectAtIndex:indexPath.row];
    }
    // perform additional custom work...
    cell.restaurantNameLabel.text = restaurant.resturantName;
    cell.restaurantAddLabel.text =restaurant.address;
    cell.numOfFavMeal.text = restaurant.favoriteMeals;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;	

    return cell;
}

#pragma mark -
#pragma mark Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RestaurantsMealListController *controller = [[RestaurantsMealListController alloc]initWithNibName:@"RestaurantsMealListController" bundle:nil];    
    if(searchBarSelected) {
        controller.restaurant = [self.filterredRestaurant objectAtIndex:indexPath.row];        
    }
    else {
        controller.restaurant = [restaurantList objectAtIndex:indexPath.row];        
    }
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Map & Location

-(void)openMap:(id)sender{
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.restaurantsTable indexPathForCell:clickedCell];
    
    MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
    UserMealInfo *obj = [[UserMealInfo alloc]init];
    Restaurant *restaurant = nil;
    if(searchBarSelected) {
        restaurant = [self.filterredRestaurant objectAtIndex:clickedButtonPath.row];
    }
    else {
        restaurant = [self.restaurantList objectAtIndex:clickedButtonPath.row];
    }
    obj.restaurant.restaurantID = restaurant.restaurantID;    
    obj.restaurant.resturantName = restaurant.resturantName;
    obj.restaurant.address = restaurant.address;    
    obj.restaurant.latitude = restaurant.latitude;
    obj.restaurant.longitude = restaurant.longitude;
    obj.restaurant.email = restaurant.email;
    obj.restaurant.website = restaurant.website;
    obj.restaurant.phoneNumber = restaurant.phoneNumber;
    obj.restaurant.favoriteMeals = restaurant.favoriteMeals;    

    mealMapController.userMealInfo = obj;
    [self.navigationController pushViewController:mealMapController animated:TRUE];
    [mealMapController release];
}


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
    
    
    DigitalPlateAppDelegate *appDel = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if([locationMeasurements count]>0) {
        CLLocation *location = [locationMeasurements objectAtIndex:[locationMeasurements count]-1];        
        
        NSString *lat = [[NSString alloc] initWithFormat:@"%g", location.coordinate.latitude];
        NSLog(@"Latitude: %@", lat);
        
        NSString *lng = [[NSString alloc] initWithFormat:@"%g", location.coordinate.longitude];
        NSLog(@"Longitude: %@", lng);
        
        NSMutableDictionary *dt1 = [[NSMutableDictionary alloc]init];
        [dt1 setObject:appDel.userInfo.UserID forKey:@"User_ID"];
        [dt1 setObject:lat forKey:@"Lat"];
        [dt1 setObject:lng forKey:@"Long"];  
        
        DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
        if(![delegate checkInternetConnectivity])
            return;

        self.restaurantList = [RequestHandler getNearByRestaurantList:dt1];        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Location could not be determined" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert release];
        [alert show];
    }


    [appDel stopActivityIndicator];
    
    if([self.restaurantList count] > 0 && [[self.restaurantList objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_NORESTAURANT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        [restaurantsTable reloadData];        
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
