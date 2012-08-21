//
//  Friends.m
//  DigitalPlate
//
//  Created by iDroid on 19/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import "Friends.h"


@implementation Friends

@synthesize UserID;
@synthesize firstName;
@synthesize lastName;
@synthesize numOfFriends;
@synthesize numOfFavMeals;
@synthesize numberOfRestaurant;
@synthesize lastMeal;

@synthesize restaurantID;
@synthesize restaurantName;
@synthesize Address;

#define KEY_USER_ID             @"User_ID"
#define KEY_USER_FNAME          @"FirstName"
#define KEY_USER_LNAME          @"LastName"
#define KEY_USER_LAST_MEAL      @"LastMeal"


#define KEY_RESTAURANT_ID       @"Restaurant_ID"
#define KEY_RESTAURANT_NAME     @"Restaurant_Name"
#define KEY_RESTAURANT_ADDRESS  @"Address"


#define KEY_FRIEND_NOFAV        @"Number_of_favourite_meals"    //
#define KEY_FRIEND_NORES        @"Number_of_favourite_restaurant"
#define KEY_FRIEND_NOFRN        @"Number_of_friends"


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) 
    {
        //([[dictionary valueForKey:@"Meal_ID"] isKindOfClass:[NSString class]])?[dictionary valueForKey:@"LastMeal"]:@"";
        
        self.UserID= ([[dictionary valueForKey:KEY_USER_ID]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_ID]:@"";
        self.firstName = ([[dictionary valueForKey:KEY_USER_FNAME]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_FNAME]:@"";        
        self.lastName = ([[dictionary valueForKey:KEY_USER_LNAME]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_LNAME]:@"";        
        self.lastMeal =([[dictionary valueForKey:KEY_USER_LAST_MEAL]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_LAST_MEAL]:@"";

        self.restaurantID =([[dictionary valueForKey:KEY_RESTAURANT_ID]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_ID]:@"";        
        self.restaurantName =([[dictionary valueForKey:KEY_RESTAURANT_NAME]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_NAME]:@"";        
        self.Address =([[dictionary valueForKey:KEY_RESTAURANT_ADDRESS]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_RESTAURANT_ADDRESS]:@"";           
        
        self.numOfFavMeals =([[dictionary valueForKey:KEY_FRIEND_NOFAV]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_FRIEND_NOFAV]:@"0";
        self.numOfFriends = ([[dictionary valueForKey:KEY_FRIEND_NOFRN]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_FRIEND_NOFRN]:@"0";
        self.numberOfRestaurant = ([[dictionary valueForKey:KEY_FRIEND_NORES]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_FRIEND_NORES]:@"0";

    }
    return self;
}


- (void)dealloc
{
    self.UserID = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.numOfFriends = nil;
    self.numOfFavMeals = nil;
    self.numberOfRestaurant = nil;
    self.lastMeal = nil;

    self.restaurantID = nil;
    self.restaurantName = nil;
    self.Address = nil;
    
    [super dealloc];
}
@end
