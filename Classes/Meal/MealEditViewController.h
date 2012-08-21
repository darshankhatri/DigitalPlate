//
//  MealEditViewController.h
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "UserMealInfo.h"
#import "RestaurantSelector.h"
#import "DAL.h"


@interface MealEditViewController : UIViewController <RatingViewDelegate, UITextViewDelegate,RestaurantSelectorDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIButton *btnCamera;
    UIButton *btnRemoveMeal;
    UIButton *btnMealName;
    UIButton *btnRestaurantName;
    UIButton *btnMealInfo;
    RatingView *ratingView;
    UserMealInfo *userMealInfo;
    DAL *database;
    
    
    UILabel *lblMeal;
    UILabel *lblRestaurant;
    UILabel *lblLocation;
    UILabel *lblInfo;
    
    UIImage *capturedImage;
	UIImagePickerController *recipePicker;

    UIImageView *recipeImage;
    NSMutableArray *arrayRestaurant;
    
    UITextView *txtMeal;
    UITextView *txtMealInfo;
    
}

@property(nonatomic, retain) IBOutlet UIButton *btnCamera;
@property(nonatomic, retain) IBOutlet UIButton *btnRemoveMeal;
@property(nonatomic, retain) IBOutlet UIButton *btnMealName;
@property(nonatomic, retain) IBOutlet UIButton *btnRestaurantName;
@property(nonatomic, retain) IBOutlet UIButton *btnMealInfo;

@property(nonatomic, retain) IBOutlet UILabel *lblMeal;
@property(nonatomic, retain) IBOutlet UILabel *lblRestaurant;
@property(nonatomic, retain) IBOutlet UILabel *lblLocation;
@property(nonatomic, retain) IBOutlet UILabel *lblInfo;

@property(nonatomic,retain) IBOutlet UIImageView *recipeImage;

@property(nonatomic, retain) UserMealInfo *userMealInfo;
@property(nonatomic, retain) RatingView *ratingView;

@property(nonatomic,retain)	UIImagePickerController *recipePicker;
@property(nonatomic,retain) UIImage *capturedImage;
@property(nonatomic,retain) NSMutableArray *arrayRestaurant;

@property(nonatomic,retain) UITextView *txtMeal;
@property(nonatomic,retain) UITextView *txtMealInfo;

-(IBAction)updateMealName:(id)sender;
-(IBAction)updateRestaurantName:(id)sender;
-(IBAction)updateLocation:(id)sender;
-(IBAction)updateInfo:(id)sender;
-(IBAction)updateImage:(id)sender;
-(IBAction)removeRestaurant:(id)sender;

@end
