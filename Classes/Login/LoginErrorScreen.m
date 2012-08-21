//
//  LoginErrorScreen.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/12/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "LoginErrorScreen.h"
#import "RegisterViewController.h"
@implementation LoginErrorScreen

@synthesize reEnterData;
@synthesize reSetPassword;

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
    [reEnterData release];
    [reSetPassword release];
    [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
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

- (IBAction)reEnterLoginData:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)resetPasswordDetail:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];    
}

-(IBAction)registerButtonClicked:(id)sender {
    
    RegisterViewController *controller = [[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
