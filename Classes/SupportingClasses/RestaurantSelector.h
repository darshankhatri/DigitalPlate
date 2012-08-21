//
//  RestaurantSelector.h
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RestaurantSelectorDelegate	 
	-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context;
@end

@interface RestaurantSelector : UIAlertView <UITableViewDelegate, UITableViewDataSource> 
{
    UITableView *myTableView;
    id<RestaurantSelectorDelegate> caller;
    id context;
    NSArray *data;
    int tableHeight;
}

-(id)initWithCaller:(id<RestaurantSelectorDelegate>)_caller data:(NSArray*)_data title:(NSString*)_title andContext:(id)_context;

@property(nonatomic, retain) id<RestaurantSelectorDelegate> caller;
@property(nonatomic, retain) id context;
@property(nonatomic, retain) NSArray *data;
@end

@interface RestaurantSelector(HIDDEN)
	-(void)prepare;
@end
