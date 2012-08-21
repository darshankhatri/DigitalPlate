//
//  FriendsMealListViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/14/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"

@interface FriendsMealListViewController : UIViewController< IconDownloaderDelegate>
{
    UITextField *searchTextField;
    UITableView *friendsTable;
    
    NSMutableArray *recentMealArr;
    NSMutableArray *friendMealListArr;    
    NSMutableArray *filteredMealArr;
    NSMutableArray *filteredFriendMealArr;
    
    BOOL searchBarSelected;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
    
    UIButton *btnUser;
}

@property(nonatomic,retain) IBOutlet UITextField *searchTextField;
@property(nonatomic,retain) IBOutlet UITableView *friendsTable;

@property(nonatomic,retain) NSMutableArray *recentMealArr;
@property(nonatomic,retain) NSMutableArray *friendMealListArr;

@property(nonatomic,retain) NSMutableArray *filteredMealArr;
@property(nonatomic,retain) NSMutableArray *filteredFriendMealArr;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

@property(nonatomic,retain) UIButton *btnUser;


-(IBAction)gotoLocationClicked:(id)sender;
- (IBAction)searchUsingContentsOfTextField:(id)sender;

-(void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
