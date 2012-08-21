//
//  FriendAndRequestListViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendAndRequestListViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *searchTextField;
    UITableView *friendsTable;
    
    NSMutableArray *friendsArray;
    NSMutableArray *requestArray;
    NSMutableArray *filteredFriendsArr;
    NSMutableArray *filteredRequestArr;
    BOOL searchBarSelected;
    
    int deleteIndex;
    int addIndex;

}

@property(nonatomic,retain) IBOutlet UITextField *searchTextField;
@property(nonatomic,retain) IBOutlet UITableView *friendsTable;

@property(nonatomic,retain) NSMutableArray *friendsArray;
@property(nonatomic,retain) NSMutableArray *requestArray;
@property(nonatomic,retain) NSMutableArray *filteredFriendsArr;
@property(nonatomic,retain) NSMutableArray *filteredRequestArr;

- (IBAction)searchUsingContentsOfTextField:(id)sender;
@end
