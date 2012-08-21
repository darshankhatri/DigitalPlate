//
//  FriendRequestCell.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendRequestCell : UITableViewCell
{
    UIImageView *friendImage;
    UILabel *friendNameLabel;
    UILabel *numOfFriendRequest;
    UILabel *numOfFavMeal;
    UILabel *numOfRestaurant;
    UIButton *deleteButton;
    UIButton *addButton;
}

@property(nonatomic,retain) IBOutlet UIImageView *friendImage;
@property(nonatomic,retain) IBOutlet UIButton *deleteButton;
@property(nonatomic,retain) IBOutlet UIButton *addButton;
@property(nonatomic,retain) IBOutlet UILabel *friendNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *numOfFriendRequest;
@property(nonatomic,retain) IBOutlet UILabel *numOfFavMeal;
@property(nonatomic,retain) IBOutlet UILabel *numOfRestaurant;
@end


