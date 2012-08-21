//
//  UserMealInfo.h
//  DigitalPlate
//
//  Created by iDroid on 22/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MealInfo.h"
#import "Restaurant.h"

@interface UserMealInfo : NSObject {
    
}

@property(nonatomic, retain) MealInfo *mealInfo;
@property(nonatomic, retain) Restaurant *restaurant;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
