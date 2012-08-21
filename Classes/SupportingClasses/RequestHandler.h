//
//  RequestHandler.h
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface RequestHandler : NSObject

+(UserInfo *) getLogin:(NSDictionary *)dict;
+(NSString *) getRegistrationList:(NSMutableDictionary *)dict;

+(NSMutableArray *) addNewRestaurant:(NSMutableDictionary*)dict;
+(NSMutableArray *) editRestaurant:(NSMutableDictionary*)dict;
+(NSMutableArray *) getRestaurantList:(NSMutableDictionary *)dict;
+(NSMutableArray *) getUserRestaurantList:(NSMutableDictionary *)dict;
+(NSMutableArray *) getTopRestaurantList:(NSMutableDictionary *)dict;
+(NSMutableArray *) getNearByRestaurantList:(NSMutableDictionary *)dict;

+(NSMutableArray *) getFriendRequestList:(NSMutableDictionary *)dict;
+(NSMutableArray *) getFriendsList:(NSMutableDictionary *)dict;
+(NSMutableArray *) confirmFriend:(NSMutableDictionary *)dict;
+(NSMutableArray *) removeFriend:(NSMutableDictionary *)dict;
+(NSMutableArray *) addNewFriend:(NSMutableDictionary*)dict;

+(NSMutableArray *) getFavMealList:(NSMutableDictionary *)dict;
+(NSMutableArray *) addMealToFav:(NSMutableDictionary *)dict;
+(NSMutableArray *) getFriendMealList:(NSMutableDictionary *)dict;
+(NSMutableArray *) getRecentMealList:(NSMutableDictionary *)dict;
+(NSMutableArray *) saveNewMeal:(NSMutableDictionary *)dict withImage:(UIImage *)image;
+(NSMutableArray *) getUserMealList:(NSMutableDictionary *)dict;
+(NSMutableArray *) getRestaurantMealList:(NSMutableDictionary *)dict;
+(NSMutableArray *) removeMeal:(NSMutableDictionary *)dict;

@end

