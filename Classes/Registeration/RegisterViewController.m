//
//  RegisterViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/13/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

#define kOFFSET_FOR_KEYBOARD 80.0

@synthesize fullNameTextField;
@synthesize passwordTextField;
@synthesize emailTextField;
@synthesize facebookTextField;
@synthesize twitterTextField;
@synthesize txtFieldLasttName;

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
    [fullNameTextField release];
    [passwordTextField release];
    [emailTextField release];
    [facebookTextField release];
    [twitterTextField release];
    [txtFieldLasttName release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




#pragma mark -
#pragma mark KeyBoard Events

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        //[self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        //[self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        //[self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        //[self setViewMovedUp:NO];
    }
}

#pragma mark -
#pragma mark Text Field Delegate 

-(void)textFieldDidBeginEditing:(UITextField *)sender {
    
    if ([sender isEqual:facebookTextField] || [sender isEqual:twitterTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
//    else {
//        if  (self.view.frame.origin.y >= 150)
//        {
//            [self setViewMovedUp:NO];
//        }        
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{              // called when 'return' key pressed. return NO to ignore.
    if(textField == fullNameTextField) {
        [txtFieldLasttName becomeFirstResponder];
    }
    else if(textField == txtFieldLasttName) {
        [passwordTextField becomeFirstResponder];
    }
    else if(textField == passwordTextField) {
        [emailTextField becomeFirstResponder];
    }
    else if(textField == emailTextField) {
        [facebookTextField becomeFirstResponder];
    }
    else if(textField == facebookTextField) {
        [twitterTextField becomeFirstResponder];
    }
    else if(textField == twitterTextField) {
        [twitterTextField resignFirstResponder];
        [self setViewMovedUp:NO];
    }
    return TRUE;
}



#pragma mark -
#pragma mark IB Outlet Actions

-(IBAction)registerClicked:(id)sender {
    
    if([emailTextField.text isEqualToString:@""] && [passwordTextField.text isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter email and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        [alertError release];
    }
    else if([emailTextField.text isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        [alertError release];
    }
    else if([passwordTextField.text isEqualToString:@""])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        [alertError release];
    }
    else if(![self validateEmail]){
        
    }
    else {
        [NSThread detachNewThreadSelector:@selector(doRegister) toTarget:self withObject:nil]; 
    }
}

-(IBAction)goBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Server Communication

- (void)doRegister {
    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRegisterDirectory) toTarget:self withObject:nil]; 
}

-(void)prepareRegisterDirectory {
    
    // Prepare Registration Dictionary.
    NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
    [dt setObject:emailTextField.text  forKey:@"email"];
    [dt setObject:passwordTextField.text forKey:@"pass"];
    [dt setObject:fullNameTextField.text forKey:@"fname"];
    [dt setObject:txtFieldLasttName.text forKey:@"lname"];
    
    //Call Registration Web service.
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(![delegate checkInternetConnectivity])
        return;
    
    NSString *strResponse = [RequestHandler getRegistrationList:dt];
    
    if([strResponse isEqualToString:@"Y"])
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"You have registered successfully.\nPlease check your email for verificaiton." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        [alertError release];
    }
    else
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        [alertError release];
    }
    [delegate stopActivityIndicator];

}

#pragma mark -
#pragma mark Other Methods

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if ([emailTextField.text length] > 150 ||  [emailTextField.text length]==0 || ![emailTest evaluateWithObject:emailTextField.text]) {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please provide valid email to Register." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return FALSE;
	}
    return TRUE;
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
