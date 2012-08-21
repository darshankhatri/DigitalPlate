//
//  MealListController.h
//  DigitalPlate
//
//  Created by iDroid on 21/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "MealDetailController.h"
#import "IconDownloader.h"
#import "DAL.h"

@class UserMealInfo;

@interface MealListController : UIViewController <RatingViewDelegate, UITextFieldDelegate, IconDownloaderDelegate>
{
    UITextField *searchTextField;
    UITableView *mealTable; 
    NSMutableArray *arrayMeals;
    
    NSMutableArray *filteredFriendMealArr;    
    NSMutableArray *distictDates;
    NSMutableArray *arrayDistMeals;
    NSString *strTodayDate;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
    
    MealDetailController *mealDetailController;
    DAL *database;

    BOOL searchBarSelected;
    BOOL isFavMeal;
}

@property(nonatomic, retain) IBOutlet UITextField *searchTextField;
@property(nonatomic, retain) IBOutlet UITableView *mealTable;

@property(nonatomic, retain) NSMutableArray *arrayMeals;
@property(nonatomic, retain) NSMutableArray *filteredFriendMealArr;
@property(nonatomic, retain) NSMutableArray *arrayDistMeals;
@property(nonatomic, retain) NSMutableArray *distictDates;
@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic, retain) NSString *strTodayDate;

@property(nonatomic, retain) MealDetailController *mealDetailController;
@property (nonatomic, readwrite) BOOL isFavMeal;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (IBAction)searchUsingContentsOfTextField:(id)sender;

@end
