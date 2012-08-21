//
//  MealInfoCell.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MealInfoCell.h"

@implementation MealInfoCell
@synthesize mealImage;
@synthesize mealNameLabel;
@synthesize mealDescriptionLabel;
@synthesize mapViewButton;

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
	[super dealloc];
}
@end
