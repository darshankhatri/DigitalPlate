//
//  MealInfoCell.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MealListCell.h"

@implementation MealListCell

@synthesize mealImage;
@synthesize mealNameLabel;
@synthesize mealDescriptionLabel;
@synthesize mapViewButton;
@synthesize ratingView;

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
    [mapViewButton release];
    [mealImage release];
    [mealNameLabel release];
    [mealDescriptionLabel release];
    [ratingView release];
	[super dealloc];
}
@end
