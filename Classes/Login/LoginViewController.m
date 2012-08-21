
//
//  LoginViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/12/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginErrorScreen.h"
#import "RegisterViewController.h"
#import "RequestHandler.h"
#import "DigitalPlateAppDelegate.h"


@implementation LoginViewController

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton;
@synthesize registerButton;

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
    
    [usernameTextField release];
    [passwordTextField release];
    [loginButton release];
    [registerButton release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    database = [[DAL alloc] init];
 
      // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated {
//    [self.usernameTextField setText:@"idroidexpert@gmail.com"];
//    [self.passwordTextField setText:@"idroid"];   
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.usernameTextField setText:([defaults stringForKey:@"Email"]?[defaults stringForKey:@"Email"]:@"")];
    [self.passwordTextField setText:([defaults stringForKey:@"Password"]?[defaults stringForKey:@"Password"]:@"")];
       
    if([self.usernameTextField.text length]!=0 && [self.passwordTextField.text length]!=0) {
        NSDictionary *ds = [defaults objectForKey:@"UserInfo"];
        UserInfo *us = [[UserInfo alloc] initWithDictionary:ds];
        DigitalPlateAppDelegate *dss = (DigitalPlateAppDelegate *)[[UIApplication sharedApplication] delegate];
        dss.userInfo = us;
        if ([dss checkInternetConnectivity]) {
            [self performSelector:@selector(uploadToServer) withObject:nil];
        }
        [self.navigationController pushViewController:dss.tabbarController animated:TRUE];
        //[self loginButtonClicked:loginButton]; 
    }
    passwordTextField.text = @"urmine";
    usernameTextField.text = @"khatridarshan@gmail.com";

    
    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark Text Field Delegate
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [self.view setCenter:CGPointMake(self.view.center.x, y - 150)];
//    [UIView commitAnimations];
//    return YES;
//}
//

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
    [textField resignFirstResponder];
//    NSLog(@"%f", y);
//    [self.view setCenter:CGPointMake(self.view.center.x, y-20)];
//    [UIView commitAnimations];
    return YES;
}


#pragma mark -
#pragma mark IB Outlet Action

-(IBAction)loginButtonClicked:(id)sender {
    
    if ([self.usernameTextField.text length]>0 && [self.passwordTextField.text length]>0) {
        [NSThread detachNewThreadSelector:@selector(doLogin) toTarget:self withObject:nil]; 
    }
    else {
        //        DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
        //        [self.navigationController pushViewController:appDelegate.tabbarController animated:TRUE];
        
        //        LoginErrorScreen *errorScreen = [[LoginErrorScreen alloc]initWithNibName:@"LoginErrorScreen" bundle:nil];
        //        [self presentModalViewController:errorScreen animated:YES];
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter credentials" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        [alertError release];
    }
}


-(IBAction)registerButtonClicked:(id)sender {
    RegisterViewController *controller = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:TRUE];
    [controller release];
}

#pragma mark -
#pragma mark Server Communication

-(void)doLogin {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 
}


-(void)prepareRequestDirectory {
    NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
    [dt setObject:self.passwordTextField.text forKey:@"Password"];
    [dt setObject:self.usernameTextField.text  forKey:@"Email"];
    
    //Prepare Request
    UserInfo *userInfo;
    
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(![appDelegate checkInternetConnectivity])
        return;
    userInfo  = [RequestHandler getLogin:dt];
    
    if([userInfo.status isEqualToString:@"yes"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.usernameTextField.text forKey:@"Email"];
        [defaults setValue:self.passwordTextField.text forKey:@"Password"];
    //    [defaults setObject:userInfo forKey:@"userInfo"];
      //  [defaults synchronize];
        appDelegate.userInfo = userInfo;
        [self performSelector:@selector(uploadToServer) withObject:nil];
        [self.navigationController pushViewController:appDelegate.tabbarController animated:TRUE];
    }
    else
    {
        LoginErrorScreen *errorScreen = [[LoginErrorScreen alloc] initWithNibName:@"LoginErrorScreen" bundle:nil];
        [self.navigationController pushViewController:errorScreen animated:TRUE];
        
        //        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertError show];
        //        [alertError release];
    }
    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate stopActivityIndicator];
    
}


#pragma mark -
#pragma mark - Database


- (void) uploadToServer
{
    
    
    database = [[DAL alloc] init];
    NSString *query =[NSString stringWithFormat:@"SELECT * FROM mealDetails"];
    NSDictionary *databaseValue = [database executeDataSet:query];
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSArray *tempArray = [databaseValue allKeys];
    for (int i = 1; i <= [tempArray count]; i++) {
        
        NSString *databaseKey = [NSString stringWithFormat:@"Table %d",i];
        NSMutableDictionary *values =  [databaseValue objectForKey:databaseKey];
        NSMutableDictionary *Meal_OBJ = [[NSMutableDictionary alloc] init];
        if ([[values valueForKey:@"flag"] isEqualToString:@"0"]) {
            [Meal_OBJ setObject:appDelegate.userInfo.UserID  forKey:@"User_ID"];
            [Meal_OBJ setValue:[values valueForKey:@"Created"] forKey:@"Created"];
            //[Meal_OBJ setValue:[values valueForKey:@"Image"] forKey:@"Image"];
            [Meal_OBJ setValue:[values valueForKey:@"Info"] forKey:@"Info"];
            [Meal_OBJ setValue:@"0" forKey:@"Is_Favorite"];
            [Meal_OBJ setValue:[values valueForKey:@"Meal_Name"] forKey:@"Name"];
            [Meal_OBJ setValue:[values valueForKey:@"Ratting"] forKey:@"Ratting"];
            [Meal_OBJ setValue:[values valueForKey:@"Restaurant_ID"] forKey:@"Restaurant_ID"];
            NSString *strMessage;
            //Prepare Request
            UIImage *imageView = [UIImage imageWithData:[NSData dataWithContentsOfFile:[values valueForKey:@"Image"]]];
            NSMutableArray *message = [RequestHandler saveNewMeal:Meal_OBJ withImage:imageView];
            for(NSDictionary *dict in message) {
                strMessage = [dict valueForKey:@"Status"];
                // Prepare Meal Dictionary.
                
                if([strMessage isEqualToString:MESSAGE_SAVE_MEAL]) {
                    
                    
                }
            }
        
        }
   
    }
    [self performSelectorInBackground:@selector(saveInDatabase) withObject:nil];
}




- (void) saveInDatabase
{
    NSString *deleteQuery = @"DELETE FROM mealDetails;";
    [database execureScalar:deleteQuery];
    deleteQuery = @"DELETE FROM restaurants;";
    [database execureScalar:deleteQuery];
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UserMealInfo *userMealInfo = nil;
    Restaurant *restaurant = nil;
    NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
    [dt setObject:appDelegate.userInfo.UserID forKey:@"User_ID"];
    NSMutableArray *arrayMeals = [RequestHandler getUserMealList:dt];
    for (int i = 0; i < [arrayMeals count]; i++) {
        
        userMealInfo = [arrayMeals objectAtIndex:i];
        UIImage* myImage = [UIImage imageWithData: 
                            [NSData dataWithContentsOfURL: 
                             [NSURL URLWithString:userMealInfo.mealInfo.image]]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int k = 0;
        if ([user valueForKey:@"imageValue"]) {
            k = [[user valueForKey:@"imageValue"]intValue];
        }
        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
                          [NSString stringWithFormat: @"%@%d.png", appDelegate.userInfo.UserID,k] ];
        
               NSData* data = UIImagePNGRepresentation(myImage);
        [data writeToFile:path atomically:YES];
        
        [path stringByAppendingFormat:@"%@%d.png",appDelegate.userInfo.UserID,k];
        k++;
        [user setValue:[NSString stringWithFormat:@"%d",k] forKey:@"imageValue"];

        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO mealDetails(Meal_Name,Restaurant_ID,Ratting, Info, Image, Meal_ID, Address, Email, Lat, Long, Restaurant_Name, Website_Detail, Created, Is_Favorite, Number_of_favourite_meal, flag) VALUES('%@','%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '1');",userMealInfo.mealInfo.meal_Name, userMealInfo.restaurant.restaurantID,userMealInfo.mealInfo.mealRating , userMealInfo.mealInfo.meal_Info, path, userMealInfo.mealInfo.meal_ID, userMealInfo.restaurant.address, userMealInfo.restaurant.email, userMealInfo.restaurant.latitude, userMealInfo.restaurant.longitude, userMealInfo.restaurant.resturantName, userMealInfo.restaurant.website, userMealInfo.mealInfo.created, userMealInfo.mealInfo.isFavorite, userMealInfo.restaurant.favoriteMeals];
        [database execureScalar:query];
    }
    NSMutableArray *arrayRestaurants = [RequestHandler getRestaurantList:dt];
    for (int j = 0; j < [arrayRestaurants count]; j++) {          
        
        restaurant = [arrayRestaurants objectAtIndex:j];
        NSString *query = [NSString stringWithFormat:@"INSERT INTO restaurants(Restaurant_Name,Restaurant_ID,Address, Lat, Long, Website_Detail, Email, flag, Number_of_favourite_meal) VALUES('%@','%@','%@', '%@', '%@', '%@' , '%@', '1', '%@');", restaurant.resturantName, restaurant.restaurantID, restaurant.address, restaurant.latitude, restaurant.longitude, restaurant.website, restaurant.email, restaurant.favoriteMeals];
        [database execureScalar:query];
    }
    NSMutableArray *arrayMyRestaurants = [RequestHandler getUserRestaurantList:dt];
    for (int j = 0; j < [arrayMyRestaurants count]; j++) {          
        
        restaurant = [arrayMyRestaurants objectAtIndex:j];
        NSString *query2 = [NSString stringWithFormat:@"INSERT INTO myRestaurants(Restaurant_Name,Restaurant_ID,Address, Lat, Long, Website_Detail, Email,Number_of_favourite_meal) VALUES('%@','%@','%@', '%@', '%@', '%@' , '%@','%@');", restaurant.resturantName, restaurant.restaurantID, restaurant.address, restaurant.latitude, restaurant.longitude, restaurant.website, restaurant.email, restaurant.favoriteMeals];
        [database execureScalar:query2];
    }

    
}





#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
