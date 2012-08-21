//
//  LatestMealCell.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "LatestMealCell.h"

@implementation LatestMealCell

@synthesize friendImage;
@synthesize mealNameLabel;
@synthesize friendNameLabel;
@synthesize numOfFriendRequest;
@synthesize numOfFavMeal;
@synthesize numberOfRestaurant;

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
    [friendImage release];
    [numberOfRestaurant release];
    [mealNameLabel release];
    [friendNameLabel release];
    [numOfFriendRequest release];
    [numOfFavMeal release];
	[super dealloc];
}
@end
