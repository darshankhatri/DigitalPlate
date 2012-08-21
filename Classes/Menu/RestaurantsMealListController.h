//
//  RestaurantsMealListController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "RatingView.h"
#import "IconDownloader.h"

@interface RestaurantsMealListController : UIViewController <UITextFieldDelegate,IconDownloaderDelegate, RatingViewDelegate>
{
    UITextField *searchTextField;
    UITableView *restaurantTable;
    
    Restaurant *restaurant;
    
    NSMutableArray *arrayRestaurantMeals;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
 
    BOOL searchBarSelected;
    NSMutableArray *filterredRestaurantMeals;

}

@property(nonatomic, retain) IBOutlet UITextField *searchTextField;
@property(nonatomic, retain) IBOutlet UITableView *restaurantTable;

@property(nonatomic, retain) Restaurant *restaurant;
@property(nonatomic, retain) NSMutableArray *arrayRestaurantMeals;
@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@property(nonatomic, retain) NSMutableArray *filterredRestaurantMeals;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (IBAction)searchUsingContentsOfTextField:(id)sender;

@end
