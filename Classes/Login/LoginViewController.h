//
//  LoginViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/12/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAL.h"
#import "Restaurant.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UIButton *loginButton;
    UIButton *registerButton;
    
    DAL *database;
    
}

@property(nonatomic, retain) IBOutlet UITextField *usernameTextField;
@property(nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, retain) IBOutlet UIButton *registerButton;

-(IBAction)loginButtonClicked:(id)sender;
-(IBAction)registerButtonClicked:(id)sender;
-(void)prepareRequestDirectory;
- (void) uploadToServer;
- (void) saveInDatabase;
@end
