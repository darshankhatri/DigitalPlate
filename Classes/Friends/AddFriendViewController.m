//
//  AddFriendViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/14/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "AddFriendViewController.h"


@implementation AddFriendViewController

@synthesize fbNameTextfield;
@synthesize emailTextField;


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
    self.fbNameTextfield = nil;
    self.emailTextField = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark  View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    self.title = @"Add Friend";
    // Do any additional setup after loading the view from its nib.
    
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
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark Bar Button Action

-(void)backButtonPressed:(id)sender {    
    //    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}


#pragma mark -
#pragma mark Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark IB Outlet Action

-(IBAction)searchButtonClicked:(id)sender {
    DigitalPlateAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    if(![appDel checkInternetConnectivity])
        return;

    NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
    [dt setObject:appDel.userInfo.UserID forKey:@"User_ID"];
//    [dt setObject:@"1" forKey:@"User_ID"];
    [dt setObject:emailTextField.text  forKey:@"email"];
    
    //Prepare Request

    [appDel startActivityIndicator];
    NSMutableArray *responseArray  = [RequestHandler addNewFriend:dt];
    
    if([responseArray count]>0 && ([[responseArray objectAtIndex:0] valueForKey:@"Status"]!=nil) && 
       [[[responseArray objectAtIndex:0] valueForKey:@"Status"] rangeOfString:@"Added"].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DigitalPlate" message:@"Friend added successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        emailTextField.text=@"";
        [appDel stopActivityIndicator];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Friend not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        emailTextField.text=@"";
        [appDel stopActivityIndicator];
    }
    
    /*
    if([response rangeOfString:@"Successfully"].location != NSNotFound || [response rangeOfString:@"Friend Added"].location != NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"DigitalPlate" message:@"Friend added successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        emailTextField.text=@"";
        [appDel stopActivityIndicator];
    }
    */
}


#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
