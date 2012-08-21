//
//  FriendRequestCell.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FriendRequestCell.h"
#import "Constant.h"
#import "DigitalPlateAppDelegate.h"
@implementation FriendRequestCell

@synthesize friendImage;
@synthesize friendNameLabel;
@synthesize numOfFriendRequest;
@synthesize numOfFavMeal;
@synthesize numOfRestaurant;
@synthesize deleteButton;
@synthesize addButton;

#pragma mark -
#pragma mark Memory Management

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)dealloc {
    [deleteButton release];
    [addButton release];
    [friendNameLabel release];
    [numOfFriendRequest release];
    [numOfFavMeal release];
    [numOfRestaurant release];
	[super dealloc];
}
@end