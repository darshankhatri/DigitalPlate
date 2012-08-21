//
//  LatestMealCell.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LatestMealCell : UITableViewCell
{
    UIImageView *friendImage;
    UILabel *mealNameLabel;
    UILabel *friendNameLabel;
    UILabel *numOfFriendRequest;
    UILabel *numOfFavMeal;
    UILabel *numberOfRestaurant;
}

@property(nonatomic,retain) IBOutlet UILabel *mealNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *friendNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *numOfFriendRequest;
@property(nonatomic,retain) IBOutlet UILabel *numOfFavMeal;
@property(nonatomic,retain) IBOutlet UILabel *numberOfRestaurant;
@property(nonatomic,retain) IBOutlet UIImageView *friendImage;

@end

