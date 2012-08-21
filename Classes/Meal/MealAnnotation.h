//
//  MealAnnotation.h
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "UserMealInfo.h"

@interface MealAnnotation : NSObject <MKAnnotation> {
    UserMealInfo *info;
}

@property(nonatomic, retain) UserMealInfo *info;

-(id)initWithUserMealInformation:(UserMealInfo *)_info;

@end
