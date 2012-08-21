//
//  UserInfo.m
//  DigitalPlate
//
//  Created by iDroid on 20/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize UserID;
@synthesize userName;
@synthesize firstName;
@synthesize lastName;
@synthesize strAddress;
@synthesize city;
@synthesize state;
@synthesize Country;
@synthesize pincode;
@synthesize password;    
@synthesize email;
@synthesize status;

#define KEY_USER_ID         @"User_ID"
#define KEY_USER_NAME       @"User_Name"
#define KEY_USER_FNAME      @"FirstName"
#define KEY_USER_LNAME      @"LastName"
#define KEY_USER_ADDRESS    @"Address"
#define KEY_USER_CITY       @"City"
#define KEY_USER_STATE      @"State"
#define KEY_USER_COUNTRY    @"Country"
#define KEY_USER_PINCODE    @"Pincode"
#define KEY_USER_PASSWORD   @"Password"
#define KEY_USER_EMAIL      @"Email"
#define KEY_USER_STATUS     @"Status"

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        self.UserID= ([[dictionary valueForKey:KEY_USER_ID] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_ID]:@"";
        self.userName= ([[dictionary valueForKey:KEY_USER_NAME] isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_NAME]:@"";        
        self.firstName = ([[dictionary valueForKey:KEY_USER_FNAME]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_FNAME]:@"";
        self.lastName = ([[dictionary valueForKey:KEY_USER_LNAME]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_LNAME]:@"";    
        self.strAddress = ([[dictionary valueForKey:KEY_USER_ADDRESS]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_ADDRESS]:@"1";            
        self.city = ([[dictionary valueForKey:KEY_USER_CITY]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_CITY]:@"";            
        self.state = ([[dictionary valueForKey:KEY_USER_STATE]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_STATE]:@"1";            
        self.Country = ([[dictionary valueForKey:KEY_USER_COUNTRY]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_COUNTRY]:@"1";            
        self.pincode = ([[dictionary valueForKey:KEY_USER_PINCODE]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_PINCODE]:@"1";            
        self.password = ([[dictionary valueForKey:KEY_USER_PASSWORD]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_PASSWORD]:@"1";                      
        self.email = ([[dictionary valueForKey:KEY_USER_EMAIL]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_EMAIL]:@"";    
        self.status = ([[dictionary valueForKey:KEY_USER_STATUS]isKindOfClass:[NSString class]])?[dictionary valueForKey:KEY_USER_STATUS]:@"1"; 
        
    }
    return self;
}

- (void)dealloc {
    
    self.UserID = nil;
    self.userName = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.strAddress = nil;
    self.city = nil;
    self.state = nil;
    self.Country = nil;
    self.pincode = nil;
    self.password = nil;   
    self.email = nil;
    self.status = nil;
    [super dealloc];
}


@end
