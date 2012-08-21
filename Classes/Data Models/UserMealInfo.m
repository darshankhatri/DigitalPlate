//
//  UserMealInfo.m
//  DigitalPlate
//
//  Created by iDroid on 22/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "UserMealInfo.h"

@implementation UserMealInfo

@synthesize mealInfo;
@synthesize restaurant;

- (id)init {
    self = [super init];
    if (self) {
        MealInfo *_mealInfo = [[MealInfo alloc] init];
        self.mealInfo = _mealInfo;
        [_mealInfo release];
        
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
        MealInfo *_mealInfo = [[MealInfo alloc] initWithDictionary:[dictionary valueForKey:@"Meal_OBJ"]];
        self.mealInfo = _mealInfo;
        [_mealInfo release];
        
        Restaurant *_restaurant = [[Restaurant alloc] initWithDictionary:[dictionary valueForKey:@"Restaurant_OBJ"]];
        self.restaurant = _restaurant;
        [_restaurant release];
    }
    return self;
}

- (void)dealloc {
    self.mealInfo = nil;
    self.restaurant = nil;
    [super dealloc];
}

@end
