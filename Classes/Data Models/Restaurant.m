//
//  Restaurant.m
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

@synthesize restaurantID;
@synthesize resturantName;
@synthesize address;
@synthesize latitude;
@synthesize longitude;
@synthesize website;
@synthesize email;
@synthesize favoriteMeals;
@synthesize phoneNumber;

#define KEY_RESTAURANT_ID       @"Restaurant_ID"
#define KEY_RESTAURANT_NAME     @"Restaurant_Name"
#define KEY_RESTAURANT_ADDRESS  @"Address"
#define KEY_RESTAURANT_LAT      @"Lat"
#define KEY_RESTAURANT_LONG     @"Long"
#define KEY_RESTAURANT_WEBSITE  @"Website_Detail"
#define KEY_RESTAURANT_EMAIL    @"Email"
#define KEY_RESTAURANT_NOF      @"Number_of_favourite_meal"


- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {        
        
        self.restaurantID = ([[dictionary valueForKey:KEY_RESTAURANT_ID] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_ID]:@"";
        self.resturantName = ([[dictionary valueForKey:KEY_RESTAURANT_NAME] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_NAME]:@"";
        self.address = ([[dictionary valueForKey:KEY_RESTAURANT_ADDRESS] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_ADDRESS]:@"";
        self.latitude = ([[dictionary valueForKey:KEY_RESTAURANT_LAT] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_LAT]:@"";
        self.longitude = ([[dictionary valueForKey:KEY_RESTAURANT_LONG] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_LONG]:@"";    
        self.website = ([[dictionary valueForKey:KEY_RESTAURANT_WEBSITE] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_WEBSITE]:@"";
        self.email = ([[dictionary valueForKey:KEY_RESTAURANT_EMAIL] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_EMAIL]:@"";
        self.favoriteMeals = ([[dictionary valueForKey:KEY_RESTAURANT_NOF] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_NOF]:@"";
        
    }
    return self;
}


- (void)dealloc
{
    self.restaurantID = nil;
    self.resturantName = nil;
    self.address = nil;
    self.latitude = nil;
    self.longitude = nil;
    self.website = nil;    
    self.email = nil;
    self.favoriteMeals = nil;
    self.phoneNumber = nil;
    
    [super dealloc];
}

@end
