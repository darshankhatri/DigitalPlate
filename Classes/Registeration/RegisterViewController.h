//
//  RegisterViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/13/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *fullNameTextField;
    UITextField *passwordTextField;
    UITextField *emailTextField;
    UITextField *facebookTextField;
    UITextField *twitterTextField;
    UITextField *txtFieldLasttName;
}

@property(nonatomic, retain) IBOutlet UITextField *fullNameTextField;
@property(nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property(nonatomic, retain) IBOutlet UITextField *emailTextField;
@property(nonatomic, retain) IBOutlet UITextField *facebookTextField;
@property(nonatomic, retain) IBOutlet UITextField *twitterTextField;
@property(nonatomic, retain) IBOutlet UITextField *txtFieldLasttName;

-(IBAction)registerClicked:(id)sender;
-(IBAction)goBackClicked:(id)sender;
-(BOOL)validateEmail;

-(void)setViewMovedUp:(BOOL)movedUp;

@end
