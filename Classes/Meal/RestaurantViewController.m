//
//  RestaurantViewController.m
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "RestaurantViewController.h"
#import "AddRestaurantViewController.h"

@implementation RestaurantViewController

@synthesize lblMealName;   
@synthesize lblAddress;
@synthesize lblWeb;
@synthesize lblEmail;

@synthesize btnFavorite;
@synthesize btnMap;
@synthesize btnCall;
@synthesize btnReservation;
@synthesize btnWebpage;
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
    [lblMealName release];  
    [lblAddress release];
    [lblWeb release];
    [lblEmail release];
    [btnFavorite release];
    [btnMap release];
    [btnCall release];
    [btnReservation release];
    [btnWebpage release];
    [userMealInfo release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    self.navigationItem.title = @"Restaurant";
    
    //set right navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(editRestaurant:) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.lblMealName.text = self.userMealInfo.restaurant.resturantName;
    self.lblAddress.text = self.userMealInfo.restaurant.address;
    self.lblEmail.text = self.userMealInfo.restaurant.email;
    self.lblWeb.text = self.userMealInfo.restaurant.website;
    
    //    self.userMealInfo.restaurant.favoriteMeals = @"10";
    
    if([self.userMealInfo.restaurant.favoriteMeals intValue]>0) {
        self.btnFavorite.titleEdgeInsets = UIEdgeInsetsMake(0, 0 , 18, -20);
        [self.btnFavorite.titleLabel setText:self.userMealInfo.restaurant.favoriteMeals];
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
#pragma mark IB Outlet Actions

-(IBAction)viewRestaurantLocation:(id)sender {
    MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
    mealMapController.userMealInfo = self.userMealInfo;
    [self.navigationController pushViewController:mealMapController animated:TRUE];
    [mealMapController release];
}

-(IBAction)callRestaurant:(id)sender {

	NSString *phoneNo = self.userMealInfo.restaurant.phoneNumber;
	
	NSString *cleanedString = [[phoneNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
	NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *devicemodel=[[UIDevice currentDevice] model];
    
	if([devicemodel hasPrefix:@"iPad"]) {        
        NSString *alertText=@"";
        
        if (phoneNo && [phoneNo length]>0) {
            alertText=[NSString stringWithString:phoneNo];
        }
        else {
            alertText=[NSString stringWithString:@"Call functionality is not available in iPad."];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
		[alert show];
		[alert release];
		return;		
	}
	
	
	if (escapedPhoneNumber.length>0)  {
        
        NSString *alertText=@"";        
        UIAlertView *alert=nil;
        
        if (phoneNo && [phoneNo length]>0) {
            alertText=[NSString stringWithString:phoneNo];
            alert = [[UIAlertView alloc] initWithTitle:@"" message:alertText delegate:self cancelButtonTitle:@"Call" otherButtonTitles:@"Cancel",nil];  
            alert.tag=100;
        }
        else {
            alertText=[NSString stringWithString:@"No telephone number provided."];
            alert = [[UIAlertView alloc] initWithTitle:@"" message:alertText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        
        }
		[alert show];
		[alert release];
    }
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No telephone number provided." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];        
        //  PG:18Jan2012
		[alert show];
		[alert release];
	}	
}

-(IBAction)makeReservation:(id)sender {    
    
//    NSString *regexString = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//    NSString *subjectString = self.userMealInfo.restaurant.website;
//    NSString *matchedString = [subjectString stringByMatching:regexString];
    
    NSURL *candidateURL = [NSURL URLWithString:self.userMealInfo.restaurant.website];
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        // candidate is a well-formed url with:
        //  - a scheme (like http://)
        //  - a host (like stackoverflow.com)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.userMealInfo.restaurant.website]];         
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.userMealInfo.restaurant.website]]];         
    }

    
}

-(IBAction)openWebPage:(id)sender {
    NSURL *candidateURL = [NSURL URLWithString:self.userMealInfo.restaurant.website];
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        // candidate is a well-formed url with:
        //  - a scheme (like http://)
        //  - a host (like stackoverflow.com)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.userMealInfo.restaurant.website]];         
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.userMealInfo.restaurant.website]]];         
    }
    
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==100 && buttonIndex == 0)  {

        NSString *phoneNo = self.userMealInfo.restaurant.phoneNumber;
        NSString *cleanedString = [[phoneNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (escapedPhoneNumber.length>0)  {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",escapedPhoneNumber]]];
        }
    }
}

#pragma mark -
#pragma mark Bar Button actions

-(void)editRestaurant:(id)sener {
    AddRestaurantViewController *controller = [[AddRestaurantViewController alloc]initWithNibName:@"AddRestaurantViewController" bundle:nil];
    controller.restaurant = self.userMealInfo.restaurant;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)backButtonPressed:(id)sender {    
    //DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
