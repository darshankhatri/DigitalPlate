//
//  SettingsViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/18/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize btnNotification;
@synthesize btnRequest;
@synthesize btnShare;

@synthesize btnLogout;

@synthesize imgYes;
@synthesize imgNo;

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
    [btnNotification release];
    [btnRequest release];
    [btnShare release];
    [btnLogout release];
    [imgYes release];
    [imgNo release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    self.imgYes = [UIImage imageNamed:@"YesSliderBtn.png"];
    self.imgNo = [UIImage imageNamed:@"NoSliderBtn.png"];
    
    [self.btnNotification setImage:self.imgYes forState:UIControlStateNormal];
    [self.btnRequest setImage:self.imgYes forState:UIControlStateNormal];
    [self.btnShare setImage:self.imgYes forState:UIControlStateNormal];
    
    self.navigationItem.title = @"Meal";
    
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
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark IB Outlet Actions

-(IBAction)actionNotification:(id)sender {
    if (btnNotification.selected == NO) {
        btnNotification.selected = !btnNotification.selected;
        [btnNotification setImage:self.imgNo forState:UIControlStateNormal];
    }
    else {
        btnNotification.selected = !btnNotification.selected;
        [btnNotification setImage:self.imgYes forState:UIControlStateNormal];        
    }
}

-(IBAction)actionRequest:(id)sender {
    if (btnRequest.selected == NO) {
        btnRequest.selected = !btnRequest.selected;
        [btnRequest setImage:self.imgNo forState:UIControlStateNormal];
    }
    else {
        btnRequest.selected = !btnRequest.selected;
        [btnRequest setImage:self.imgYes forState:UIControlStateNormal];        
    }
}

-(IBAction)actionShare:(id)sender {
    if (btnShare.selected == NO) {
        btnShare.selected = !btnShare.selected;
        [btnShare setImage:self.imgNo forState:UIControlStateNormal];
    }
    else {
        btnShare.selected = !btnShare.selected;
        [btnShare setImage:self.imgYes forState:UIControlStateNormal];        
    }
}

-(IBAction)logoutClicked:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:@"Email"];
    [defaults setValue:nil forKey:@"Password"];
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController popToRootViewControllerAnimated:TRUE];
}


#pragma mark -
#pragma mark Bar Button Actions


-(void)backButtonPressed:(id)sender {    
//    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
