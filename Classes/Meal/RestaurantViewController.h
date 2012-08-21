//
//  RestaurantViewController.h
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MealMapController.h"
#import "UserMealInfo.h"

@interface RestaurantViewController : UIViewController {
    UILabel *lblAddress;
    UILabel *lblWeb;
    UILabel *lblEmail;    
    UILabel *lblMealName;    
    
    UIButton *btnFavorite;
    UIButton *btnMap;
    
    UIButton *btnCall;
    UIButton *btnReservation;
    UIButton *btnWebpage; 
    
    UserMealInfo *userMealInfo;
}

@property(nonatomic, retain) IBOutlet UILabel *lblMealName;    
@property(nonatomic, retain) IBOutlet UILabel *lblAddress;
@property(nonatomic, retain) IBOutlet UILabel *lblWeb;
@property(nonatomic, retain) IBOutlet UILabel *lblEmail;

@property(nonatomic, retain) IBOutlet UIButton *btnFavorite;
@property(nonatomic, retain) IBOutlet UIButton *btnMap;

@property(nonatomic, retain) IBOutlet UIButton *btnCall;
@property(nonatomic, retain) IBOutlet UIButton *btnReservation;
@property(nonatomic, retain) IBOutlet UIButton *btnWebpage;

@property(nonatomic, retain) UserMealInfo *userMealInfo;

-(IBAction)viewRestaurantLocation:(id)sender;
-(IBAction)callRestaurant:(id)sender;
-(IBAction)makeReservation:(id)sender;
-(IBAction)openWebPage:(id)sender;

@end
