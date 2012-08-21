//
//  MenuListViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *menuTable;
}

@property(nonatomic, retain) IBOutlet UITableView *menuTable;

@end
