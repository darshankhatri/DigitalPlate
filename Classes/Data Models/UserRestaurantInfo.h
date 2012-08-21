//
//  UserRestaurantInfo.h
//  DigitalPlate
//
//  Created by iDroid on 3/24/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "Restaurant.h"
@interface UserRestaurantInfo : NSObject {
    
}

@property(nonatomic, retain) UserInfo *userInfo;
@property(nonatomic, retain) Restaurant *restaurant;

- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
