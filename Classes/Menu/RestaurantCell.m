//
//  RestaurantCell.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "RestaurantCell.h"

@implementation RestaurantCell

@synthesize restaurantAddLabel;
@synthesize restaurantNameLabel;
@synthesize numOfFavMeal;
@synthesize mapViewButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [restaurantAddLabel release];
    [restaurantNameLabel release];
    [numOfFavMeal release];
    [mapViewButton release];
    [super dealloc];
}
@end
