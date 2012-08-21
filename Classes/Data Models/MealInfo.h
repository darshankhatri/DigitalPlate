//
//  MealInfo.h
//  DigitalPlate
//
//  Created by iDroid on 3/19/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealInfo : UITableViewCell {
    
}

@property(nonatomic,retain) NSString *meal_ID;
@property(nonatomic,retain) NSString *meal_Name;
@property(nonatomic,retain) NSString *image;
@property(nonatomic,retain) NSString *meal_Info;
@property(nonatomic,retain) NSString *mealRating;
@property(nonatomic,retain) NSString *created;
@property(nonatomic,retain) NSString *isFavorite;
@property(nonatomic,retain) UIImage *mealImage;


- (id)initWithDictionary:(NSDictionary *)dictionary;
@end