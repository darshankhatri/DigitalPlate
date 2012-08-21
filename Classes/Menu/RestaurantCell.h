//
//  RestaurantCell.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantCell : UITableViewCell
{
    UILabel *restaurantNameLabel;
    UILabel *restaurantAddLabel;
    UILabel *numOfFavMeal;
    UIButton *mapViewButton;
 
}

@property(nonatomic,retain) IBOutlet UILabel *restaurantNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *restaurantAddLabel;
@property(nonatomic,retain) IBOutlet UILabel *numOfFavMeal;
@property(nonatomic,retain) IBOutlet UIButton *mapViewButton;

@end
