//
//  FriendRequest.m
//  DigitalPlate
//
//  Created by iDroid on 27/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FriendRequest.h"

@implementation FriendRequest

@synthesize userInfo; 
@synthesize numberOfFavorites;
@synthesize numberOfRestaurant;
@synthesize numberOfFriends;

#define KEY_USER_ID         @"User_ID"
#define KEY_USER_FNAME      @"FirstName"
#define KEY_USER_LNAME      @"LastName"
#define KEY_USER_ADDRESS    @"Address"
#define KEY_USER_CITY       @"City"
#define KEY_USER_STATE      @"State"
#define KEY_USER_COUNTRY    @"Country"
#define KEY_USER_PINCODE    @"Pincode"
#define KEY_USER_EMAIL      @"Email"

#define KEY_FRIEND_NOFAV    @"Number_of_favourite_meal"
#define KEY_FRIEND_NORES    @"Number_of_favourite_restaurant"
#define KEY_FRIEND_NOFRN    @"Number_of_friends"


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self)
    {
        NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_ID] forKey:KEY_USER_ID];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_FNAME] forKey:KEY_USER_FNAME];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_LNAME] forKey:KEY_USER_LNAME];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_ADDRESS] forKey:KEY_USER_ADDRESS];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_CITY] forKey:KEY_USER_CITY];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_STATE] forKey:KEY_USER_STATE];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_COUNTRY] forKey:KEY_USER_COUNTRY];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_PINCODE] forKey:KEY_USER_PINCODE];
        [userDictionary setValue:[dictionary valueForKey:KEY_USER_EMAIL] forKey:KEY_USER_EMAIL];
        
        self.userInfo = [[UserInfo alloc] initWithDictionary:userDictionary];
        
        self.numberOfFavorites = ([[dictionary valueForKey:KEY_FRIEND_NOFAV] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_FRIEND_NOFAV]:@"0";
        self.numberOfRestaurant = ([[dictionary valueForKey:KEY_FRIEND_NORES] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_FRIEND_NORES]:@"0";
        self.numberOfFriends = ([[dictionary valueForKey:KEY_FRIEND_NOFRN] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_FRIEND_NOFRN]:@"0";        
        [userDictionary release];

    }
    return  self;
}

- (void)dealloc {
    
    self.userInfo = nil;
    self.numberOfFavorites = nil;
    self.numberOfFriends = nil;
    self.numberOfRestaurant = nil;
    
    [super dealloc];
}


@end
