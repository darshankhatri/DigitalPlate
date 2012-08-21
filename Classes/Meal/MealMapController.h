//
//  MealMapController.h
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UserMealInfo.h"

@interface MealMapController : UIViewController
{
    MKMapView *mapView;
    UserMealInfo *userMealInfo;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) UserMealInfo *userMealInfo;

@end
