//
//  UserInfo.h
//  DigitalPlate
//
//  Created by iDroid on 20/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject {

}

@property(nonatomic, retain) NSString *UserID;
@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *strAddress;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *Country;
@property(nonatomic, retain) NSString *pincode;
@property(nonatomic, retain) NSString *password;    
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *status;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
