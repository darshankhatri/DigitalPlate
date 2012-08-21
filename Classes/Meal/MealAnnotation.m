//
//  MealAnnotation.m
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MealAnnotation.h"
#import "UserMealInfo.h"

@implementation MealAnnotation

@synthesize coordinate;
@synthesize info;

- (NSString *)subtitle{
	return self.info.restaurant.address;
}

- (NSString *)title{
	return [NSString stringWithFormat:@"🍸 %@",self.info.restaurant.resturantName];
}

-(CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.info.restaurant.latitude doubleValue], [self.info.restaurant.longitude doubleValue]);
    return coord; 
}

-(id)initWithUserMealInformation:(UserMealInfo *)_info {
    self = [super init];
    if (self) {
        self.info = _info;
    }
    return self;
}

@end
