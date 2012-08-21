//
//  SettingsViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/18/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
{
    UIButton *btnNotification;
    UIButton *btnRequest;
    UIButton *btnShare;
    
    UIButton *btnLogout;
    
    UIImage *imgYes;
    UIImage *imgNo;
}

@property(nonatomic, retain) IBOutlet UIButton *btnNotification;
@property(nonatomic, retain) IBOutlet UIButton *btnRequest;
@property(nonatomic, retain) IBOutlet UIButton *btnShare;

@property(nonatomic, retain) IBOutlet UIButton *btnLogout;

@property(nonatomic, retain) UIImage *imgYes;
@property(nonatomic, retain) UIImage *imgNo;

-(IBAction)actionNotification:(id)sender;
-(IBAction)actionRequest:(id)sender;
-(IBAction)actionShare:(id)sender;
-(IBAction)logoutClicked:(id)sender;

@end
