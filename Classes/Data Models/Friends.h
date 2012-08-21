//
//  Friends.h
//  DigitalPlate
//
//  Created by iDroid on 19/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Friends : NSObject {

}

@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *numOfFriends;
@property(nonatomic, retain) NSString *numOfFavMeals;
@property(nonatomic, retain) NSString *numberOfRestaurant;
@property(nonatomic, retain) NSString *lastMeal;

@property(nonatomic, retain) NSString *restaurantID;
@property(nonatomic, retain) NSString *restaurantName;
@property(nonatomic, retain) NSString *Address;


- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
