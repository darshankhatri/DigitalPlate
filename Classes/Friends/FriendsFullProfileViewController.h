//
//  FriendsFullProfileViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/16/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friends.h"
#import "IconDownloader.h"
#import "RatingView.h"

@interface FriendsFullProfileViewController : UIViewController<RatingViewDelegate, UITextFieldDelegate, IconDownloaderDelegate>
{
    UITextField *searchTextField;
    UITableView *friendsTable;
    
    NSMutableArray *favMealList;
    NSMutableArray *filteredMealList;    
    
    Friends *friendProfile;
    BOOL searchBarSelected;

    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
}

@property (nonatomic,retain) IBOutlet UITextField *searchTextField;
@property (nonatomic,retain) IBOutlet UITableView *friendsTable;

@property (nonatomic,retain) NSMutableArray *filteredMealList;
@property (nonatomic,retain) NSMutableArray *favMealList;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

@property (nonatomic,assign) Friends *friendProfile;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (IBAction)searchUsingContentsOfTextField:(id)sender;

@end
