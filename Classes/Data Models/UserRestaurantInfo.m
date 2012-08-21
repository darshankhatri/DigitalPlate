//
//  UserRestaurantInfo.m
//  DigitalPlate
//
//  Created by iDroid on 3/24/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "UserRestaurantInfo.h"

@implementation UserRestaurantInfo

@synthesize userInfo;
@synthesize restaurant;

- (id)init {
    self = [super init];
    if (self) {
        UserInfo *_userInfo = [[UserInfo alloc] init];
        self.userInfo = _userInfo;
        [_userInfo release];
        
        Restaurant *_restaurant = [[Restaurant alloc] init];
        self.restaurant = _restaurant;
        [_restaurant release];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self)
    {
        UserInfo *_userInfo = [[UserInfo alloc] initWithDictionary:[dictionary valueForKey:@"User_OBJ"]];
        self.userInfo = _userInfo;
        [_userInfo release];
        
        Restaurant *_restaurant = [[Restaurant alloc] initWithDictionary:[dictionary valueForKey:@"Restaurant_OBJ"]];
        self.restaurant = _restaurant;
        [_restaurant release];
    }
    return self;
}

- (void)dealloc {
    self.userInfo = nil;
    self.restaurant = nil;
    [super dealloc];
}
@end
