//
//  MealInfoCell.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface MealListCell : UITableViewCell {
    
    UIImageView *mealImage;
    UILabel *mealNameLabel;
    UILabel *mealDescriptionLabel;
    UIButton *mapViewButton;
    RatingView *ratingView;
}

@property(nonatomic,retain) IBOutlet UIImageView *mealImage;
@property(nonatomic,retain) IBOutlet UILabel *mealNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *mealDescriptionLabel;
@property(nonatomic,retain) IBOutlet UIButton *mapViewButton;
@property(nonatomic,retain) IBOutlet RatingView *ratingView;

@end
