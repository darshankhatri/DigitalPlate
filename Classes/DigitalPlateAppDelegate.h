//
//  DigitalPlateAppDelegate.h
//  DigitalPlate
//
//  Created by iDroid on 12/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "CustomActivityIndicatorView.h"
#import "UserInfo.h"
#import "Reachability.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "FriendsMealListViewController.h"
#import "DAL.h"
#import "UserMealInfo.h"

@interface DigitalPlateAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	TabBarViewController *tabbarController;
    CustomActivityIndicatorView *indicatorView;
    
    // Set the id when getting response from login
    //NSString *CurrentUserID;
    UserInfo *userInfo;
    
    DAL *database;
    NSString *databaseName;
    NSString *databasePath;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet TabBarViewController *tabbarController;
@property (nonatomic, retain) CustomActivityIndicatorView *indicatorView;
//@property (nonatomic, retain) NSString *CurrentUserID;
@property (nonatomic, retain) UserInfo *userInfo;


-(void)startActivityIndicator;
-(void)stopActivityIndicator;
-(BOOL) checkInternetConnectivity;
+(BOOL)isNetworkAvailable;
@end

