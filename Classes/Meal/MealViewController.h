//
//  MealViewController.h
//  DigitalPlate
//
//  Created by iDroid on 17/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "Restaurant.h"
#import "RestaurantSelector.h"
#import "faceBook.h"
#import "Twitter.h"
#import "UserMealInfo.h"
#import "DAL.h"

@interface MealViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RatingViewDelegate, UITextFieldDelegate, RestaurantSelectorDelegate, UITextViewDelegate, FaceBookDelegate> {
    
	UIView *detailView;
	UIImageView *recipeImage;
    UIImage *capturedImage;
	UIImagePickerController *recipePicker;
    
    NSMutableArray *arrayRestaurant;
    
    UIButton *mealUpdateButton;
    UIButton *restaurantButton;
    UIButton *locationButton;
    UIButton *infoButton;
    UIButton *btnFB;
    UIButton *btnTW;    
    
    UITextView *txtMeal;
    UILabel *lblMeal;
    UILabel *lblRestaurant;
    UILabel *lblLocation;
    UILabel *lblInfo;    
    
    UITextView *txtMealInfo;
    UITextField *txtFieldFB;
    UIAlertView *alrtFB;    
    
    RatingView *ratingView;
    faceBook *objFacebook;
    Twitter *objTwitter;
    UserMealInfo *userMealInfo;
    
    BOOL isModaledController;
    
    DAL *database;
}

@property(nonatomic,retain) IBOutlet UIView *detailView;
@property(nonatomic,retain) IBOutlet UIImageView *recipeImage;
@property(nonatomic,retain) IBOutlet UIButton *mealUpdateButton;
@property(nonatomic,retain) IBOutlet UIButton *restaurantButton;
@property(nonatomic,retain) IBOutlet UIButton *locationButton;
@property(nonatomic,retain) IBOutlet UIButton *infoButton;
@property(nonatomic,retain) IBOutlet UILabel *lblMeal;
@property(nonatomic,retain) IBOutlet UILabel *lblRestaurant;
@property(nonatomic,retain) IBOutlet UILabel *lblLocation;
@property(nonatomic,retain) IBOutlet UILabel *lblInfo;
@property(nonatomic,retain) IBOutlet UIButton *btnFB;
@property(nonatomic,retain) IBOutlet UIButton *btnTW;

@property(nonatomic,retain) faceBook *objFacebook;
@property(nonatomic,retain) Twitter *objTwitter;
@property(nonatomic,retain) RatingView *ratingView;
@property(nonatomic,retain) UserMealInfo *userMealInfo;

@property(nonatomic,retain) UIImage *capturedImage;
@property(nonatomic,retain) UITextField *txtFieldFB;
@property(nonatomic,retain) UIAlertView *alrtFB;
@property(nonatomic,retain) UITextView *txtMeal;
@property(nonatomic,retain) UITextView *txtMealInfo;
@property(nonatomic,retain)	UIImagePickerController *recipePicker;
@property(nonatomic,retain) NSMutableArray *arrayRestaurant;

-(IBAction)callFB:(id)sender;
-(IBAction)callTW:(id)sender;

@end
