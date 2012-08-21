//
//  FriendMealInfoViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMealInfo.h"
#import "RatingView.h"
@interface FriendMealInfoViewController : UIViewController <UIScrollViewDelegate>
{
    UIImageView *mealImage;
    UIButton *moreButton;
    UITextView *descriptionTextView;
    UILabel *mealName;
    
    UserMealInfo *meal;
    RatingView *ratingView;
}

@property(nonatomic, retain) IBOutlet UIImageView *mealImage;
@property(nonatomic, retain) IBOutlet UIButton *moreButton;
@property(nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property(nonatomic, retain) IBOutlet UILabel *mealName;

@property(nonatomic,retain) RatingView *ratingView;
@property(nonatomic,assign) UserMealInfo *meal;

-(IBAction)goToRestaurantClicked:(id)sender;
-(IBAction)gotoLocationClicked:(id)sender;
-(IBAction)zoomInMealImage:(id)sender;
-(IBAction)moreButtonClicked:(id)sender;



@end
