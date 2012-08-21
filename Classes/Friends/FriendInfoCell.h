//
//  FriendInfoCell.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/14/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendInfoCell : UITableViewCell
{
    UIImageView *friendImage;
    UILabel *friendNameLabel;
    UILabel *restaurantNameLabel;
    UILabel *restaurantAddLabel;
    UILabel *timeLabel;
    UIButton *locationButton;
}

@property(nonatomic,retain) IBOutlet UIButton *locationButton;
@property(nonatomic,retain) IBOutlet UIImageView *friendImage;
@property(nonatomic,retain) IBOutlet UILabel *friendNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *restaurantNameLabel;
@property(nonatomic,retain) IBOutlet UILabel *restaurantAddLabel;
@property(nonatomic,retain) IBOutlet UILabel *timeLabel;

@end
