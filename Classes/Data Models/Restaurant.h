//
//  Restaurant.h
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject {
    
}

@property(nonatomic, retain) NSString *restaurantID;
@property(nonatomic, retain) NSString *resturantName;
@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *latitude;
@property(nonatomic, retain) NSString *longitude;
@property(nonatomic, retain) NSString *website;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *favoriteMeals;
@property(nonatomic, retain) NSString *phoneNumber;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
