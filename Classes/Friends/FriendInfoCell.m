//
//  FriendInfoCell.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/14/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FriendInfoCell.h"

@implementation FriendInfoCell
@synthesize friendImage;
@synthesize friendNameLabel;
@synthesize restaurantNameLabel;
@synthesize restaurantAddLabel;
@synthesize timeLabel;
@synthesize locationButton;

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
    [locationButton release];
    [friendImage release];
    [friendNameLabel release];
    [restaurantNameLabel release];
    [restaurantAddLabel release];
    [timeLabel release];
	[super dealloc];
}
@end
