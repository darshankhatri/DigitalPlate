	//
//  RequestHandler.m
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "RequestHandler.h"
#import "Restaurant.h"
#import "Friends.h"
#import "MealInfo.h"
#import "UserMealInfo.h"
#import "UserRestaurantInfo.h"

#import "FriendRequest.h"

@implementation RequestHandler

#pragma mark -
#pragma mark LOGIN/REG

+(UserInfo *) getLogin:(NSDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_LOGIN];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    UserInfo *userInfo = nil;
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        NSLog(@"requestString :%@",requestString);        
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
        [arr release];
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);
    [returnString release];
    NSUserDefaults *ds = [NSUserDefaults standardUserDefaults];
    for (NSDictionary *dictionary in returnArray) {
        [ds setObject:dictionary forKey:@"UserInfo"];
        [ds synchronize];
        userInfo = [[UserInfo alloc] initWithDictionary:dictionary];
    }
    return [userInfo autorelease];
}


+(NSString *) getRegistrationList:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_REGISTER];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    return returnString;
}


#pragma mark -
#pragma mark RESTAURANT

+(NSMutableArray *) addNewRestaurant:(NSMutableDictionary*)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_ADD_RESTAURANT];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    //    UserInfo *userInfo = nil;
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSLog(@"returnString :%@",returnString); 
    
    NSMutableArray *returnArray = [returnString JSONValue];
    return returnArray;    
}


+(NSMutableArray *) editRestaurant:(NSMutableDictionary*)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_EDIT_RESTAURANT];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    //    UserInfo *userInfo = nil;
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSLog(@"returnString :%@",returnString); 
    
    NSMutableArray *returnArray = [returnString JSONValue];
    return returnArray;    
}


+(NSMutableArray *) getRestaurantList:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_RESTAURANT];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];   
        [arr release];
    }

	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString); 
    [returnString release];
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:dictionary];
            [responseArray addObject:restaurant];
        }
        return [responseArray autorelease];
    }
}


+(NSMutableArray *) getUserRestaurantList:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_USER_RESTAURANT];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
        [arr release];
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);    
    [returnString release];
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:dictionary];
            [responseArray addObject:restaurant];
        }        
        return [responseArray autorelease];
    }
}


+(NSMutableArray *) getTopRestaurantList:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_TOP_RESTAURANT];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
        [arr release];
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);  
    [returnString release];
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:dictionary];
            [responseArray addObject:restaurant];
        }        
        return [responseArray autorelease];        
    }
}


+(NSMutableArray *) getNearByRestaurantList:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_NEARBY_RESTAURANT];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        NSLog(@"requestString :%@",requestString);
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
        [arr release];
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);
    [returnString release];
    
        if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:dictionary];
            [responseArray addObject:restaurant];
        }        
        return [responseArray autorelease];
    }
}


#pragma mark -
#pragma mark FRIENDS

+(NSMutableArray *) getFriendRequestList:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_FRIEND_REQUESTLIST];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    if([returnString rangeOfString:@"["].location ==NSNotFound)
    {
        returnString = [NSString stringWithFormat:@"[%@]",returnString];
    }
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);    
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"])
    {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            FriendRequest *friendRequest = [[FriendRequest alloc] initWithDictionary:dictionary];
            [responseArray addObject:friendRequest];
        }        
    }
    return responseArray;    
}


+(NSMutableArray *) getFriendsList:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_RETRIEVE_FRIENDS];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    if([returnString rangeOfString:@"["].location ==NSNotFound)
    {
        returnString = [NSString stringWithFormat:@"[%@]",returnString];
    }

    
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);    
       
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) 
    {
         NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            Friends *friend = [[Friends alloc] initWithDictionary:dictionary];
            [responseArray addObject:friend];
        }        
    }
    return responseArray;
    

}


+(NSMutableArray *) confirmFriend:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_CONFIRM_FRIEND]; 
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        NSLog(@"requestString :%@",requestString);
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    NSLog(@"returnString :%@",returnString); 
    
    NSMutableArray *returnArray = [returnString JSONValue];
    return returnArray;
    
}


+(NSMutableArray *) removeFriend:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_REMOVE_FRIEND]; 
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        NSLog(@"requestString :%@",requestString);
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    NSLog(@"returnString :%@",returnString); 
    
    NSMutableArray *returnArray = [returnString JSONValue];
    return returnArray;
    
}


+(NSMutableArray *) addNewFriend:(NSMutableDictionary*)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_ADD_FRIEND];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
//    UserInfo *userInfo = nil;
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);    
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        return nil;
    }

    //return returnString;
}


#pragma mark -
#pragma mark MEAL

+(NSMutableArray *) getFavMealList:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_FAV_MEALLIST];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);    
    
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"])
    {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            UserMealInfo *mealInfo = [[UserMealInfo alloc] initWithDictionary:dictionary];
            [responseArray addObject:mealInfo];
        }
    }
    
    
    return responseArray;
}


+(NSMutableArray *) addMealToFav:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_ADD_MEAL_FAV]; 
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    
    if(dict!=nil)
    {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        NSLog(@"requestString :%@",requestString);
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    NSLog(@"returnString :%@",returnString); 
    
    NSMutableArray *returnArray = [returnString JSONValue];
    return returnArray;
    
    
}


+(NSMutableArray *) getFriendMealList:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_FRIEND_MEALLIST];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    if([returnString rangeOfString:@"["].location ==NSNotFound)
    {
        returnString = [NSString stringWithFormat:@"[%@]",returnString];
    }
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);    
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"])
    {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            UserRestaurantInfo *userRest = [[UserRestaurantInfo alloc] initWithDictionary:dictionary];
            [responseArray addObject:userRest];
        }
    }
    return responseArray;
}


+(NSMutableArray *) getRecentMealList:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_RECENT_MEALLIST];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    if([returnString rangeOfString:@"["].location ==NSNotFound)
    {
        returnString = [NSString stringWithFormat:@"[%@]",returnString];
    }
    
    
    NSMutableArray *returnArray = [returnString JSONValue];
    NSLog(@"returnString :%@",returnString);    
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"])
    {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            UserMealInfo *meal = [[UserMealInfo alloc] initWithDictionary:dictionary];
            [responseArray addObject:meal];
        }
    }
    return responseArray;    
}


+(NSMutableArray *) saveNewMeal:(NSMutableDictionary *)dict withImage:(UIImage *)image {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_SAVE_MEAL]; 
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    //    UserInfo *userInfo = nil;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [dict removeObjectForKey:@"userfile"]; 
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestString = [NSString stringWithFormat:@"%@,\"userfile\":\"%@\"}]",[requestString substringWithRange:NSMakeRange(0, requestString.length-2)],imageData];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        requestString = [requestString stringByReplacingOccurrencesOfString:@">" withString:@""];         
        NSLog(@"requestString :%@",requestString);
        
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    //    if([returnString rangeOfString:@"["].location ==NSNotFound)
    //    {
    //        returnString = [NSString stringWithFormat:@"[%@]",returnString];
    //    }
    //    NSLog(@"returnString :%@",returnString);  
    //    returnString = [NSString stringWithFormat:@"[%@]",returnString];
    
    NSLog(@"returnString :%@",returnString); 
    
    NSMutableArray *returnArray = [returnString JSONValue];
    return returnArray;
    
}


+(NSMutableArray *) getUserMealList:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_USER_MEAL_LIST];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    NSMutableArray *returnArray = [returnString JSONValue];
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            UserMealInfo *userMealInfo = [[UserMealInfo alloc] initWithDictionary:dictionary];
            [responseArray addObject:userMealInfo];
        }        
    }    
    return responseArray;
    
}


+(NSMutableArray *) getRestaurantMealList:(NSMutableDictionary *)dict {
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_RESTAURANT_MEAL];
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
    NSMutableArray *responseArray = [[NSMutableArray alloc] init];
    
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    NSMutableArray *returnArray = [returnString JSONValue];
    
    if([returnArray count]==1 && [[[returnArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        NSLog(@"Returning Array :%@",returnArray);
        return returnArray;
    }
    else {
        for (NSDictionary *dictionary in returnArray) {
            UserMealInfo *userMealInfo = [[UserMealInfo alloc] initWithDictionary:dictionary];
            [responseArray addObject:userMealInfo];
        }        
    }    
    return responseArray;
    
}


+(NSMutableArray *) removeMeal:(NSMutableDictionary *)dict {
    
    NSString *appURL = [NSString stringWithFormat:@"%@%@", REQUEST_URL, REQUEST_REMOVE_MEAL]; 
    
    NSData *requestData = nil;
    NSMutableArray *arr = nil; 
    NSString *requestString = nil;
        
    if(dict!=nil) {
        arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        requestString = [NSString stringWithFormat:@"message=%@", [arr JSONFragment], nil];
        NSLog(@"requestString :%@",requestString);
        requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];        
    }
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appURL]];
	[request setHTTPMethod: @"POST"];	
    [request setHTTPBody:requestData];
    
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    
    NSLog(@"returnString :%@",returnString); 
    
    NSMutableArray *returnArray = [returnString JSONValue];
    return returnArray;
    
}


@end
