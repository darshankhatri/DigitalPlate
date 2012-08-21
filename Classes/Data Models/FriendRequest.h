//
//  FriendRequest.h
//  DigitalPlate
//
//  Created by iDroid on 27/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface FriendRequest : NSObject {
    
}

@property(nonatomic, retain) UserInfo *userInfo; 
@property(nonatomic, retain) NSString *numberOfFavorites;
@property(nonatomic, retain) NSString *numberOfRestaurant;
@property(nonatomic, retain) NSString *numberOfFriends;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
