//
//  MealInfo.m
//  DigitalPlate
//
//  Created by iDroid on 3/19/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//
#import "MealInfo.h"

@implementation MealInfo

@synthesize meal_ID;
@synthesize meal_Name;
@synthesize image;
@synthesize meal_Info;
@synthesize mealRating;
@synthesize created;
@synthesize isFavorite;
@synthesize mealImage;

#define KEY_MEAL_ID         @"Meal_ID"
#define KEY_MEAL_NAME       @"Meal_Name"
#define KEY_MEAL_IMAGE      @"Image"
#define KEY_MEAL_INFO       @"Info"
#define KEY_MEAL_RATTING    @"Ratting"
#define KEY_MEAL_CREATED    @"Created"
#define KEY_MEAL_ISFAV      @"Is_Favorite"


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.meal_ID= ([[dictionary valueForKey:KEY_MEAL_ID] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_MEAL_ID]:@"";
        self.meal_Name = ([[dictionary valueForKey:KEY_MEAL_NAME] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_MEAL_NAME]:@"";
        self.image = ([[dictionary valueForKey:KEY_MEAL_IMAGE] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_MEAL_IMAGE]:@"";
        if (([self.image rangeOfString:@"http://"].location == NSNotFound) && ([self.image  rangeOfString:@"https://"].location == NSNotFound)) {
            self.image  = [NSString stringWithFormat:@"http://%@",self.image ];
        }
        self.meal_Info = ([[dictionary valueForKey:KEY_MEAL_INFO] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_MEAL_INFO]:@"";
        self.mealRating = ([[dictionary valueForKey:KEY_MEAL_RATTING] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_MEAL_RATTING]:@"";
        self.created = ([[dictionary valueForKey:KEY_MEAL_CREATED] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_MEAL_CREATED]:@"";
        self.isFavorite = ([[dictionary valueForKey:KEY_MEAL_ISFAV] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_MEAL_ISFAV]:@"";
    }
    return self;
}


- (void)dealloc
{
    self.meal_ID = nil;
    self.meal_Name = nil;
    self.image = nil;
    self.meal_Info = nil;
    self.mealRating = nil;
    self.created = nil;
    self.isFavorite = nil;
    
    [mealImage release];

    [super dealloc];
}

@end
