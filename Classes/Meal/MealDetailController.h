//
//  MealDetailController.h
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "UserMealInfo.h"
#import "MealEditViewController.h"
#import "RestaurantViewController.h"
#import "faceBook.h"
#import "Twitter.h"

@interface MealDetailController : UIViewController <RatingViewDelegate, FaceBookDelegate, UIScrollViewDelegate>
{
    UILabel *lblMealName;
    UIButton *btnRestaurant;
    UIButton *btnMap;
    UIButton *btnShare;
    UIImageView *imgMeal;
    UITextView *txtMealInfo;
    UIAlertView *alertViewSocialNet;    
    UIAlertView *alrtFB;
    UITextField *txtFieldFB;
    
    UserMealInfo *userMealInfo;
    MealEditViewController *mealEditController;
    RestaurantViewController *restaurantController;
    faceBook *objFacebook;
    Twitter *objTwitter;
    RatingView *ratingView;
    
}

@property(nonatomic, retain) IBOutlet UILabel *lblMealName;
@property(nonatomic, retain) IBOutlet UIButton *btnRestaurant;
@property(nonatomic, retain) IBOutlet UIButton *btnMap;
@property(nonatomic, retain) IBOutlet UIButton *btnShare;
@property(nonatomic, retain) IBOutlet UIImageView *imgMeal;
@property(nonatomic, retain) IBOutlet UITextView *txtMealInfo;

@property(nonatomic, retain) UIAlertView *alertViewSocialNet;
@property(nonatomic, retain) UITextField *txtFieldFB;
@property(nonatomic, retain) UIAlertView *alrtFB;

@property(nonatomic, retain) RatingView *ratingView;
@property(nonatomic, retain) MealEditViewController *mealEditController;
@property(nonatomic, retain) RestaurantViewController *restaurantController;
@property(nonatomic, retain) UserMealInfo *userMealInfo;
@property(nonatomic, retain) faceBook *objFacebook;
@property(nonatomic, retain) Twitter *objTwitter;


-(void)callFB;
-(void)callTW;

-(IBAction)zoomInMealImage:(id)sender;

@end
