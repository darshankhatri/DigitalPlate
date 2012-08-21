//
//  MenuListViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MenuListViewController.h"
#import "MyRestaurantsListViewController.h"
#import "SettingsViewController.h"
#import "MealListController.h"

@implementation MenuListViewController

@synthesize menuTable;

#pragma mark -
#pragma mark Memory Management


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    self.menuTable.dataSource = nil;
    self.menuTable.delegate = nil;
    self.menuTable = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    [super viewDidLoad];
    //self.title = @"Menu";
	self.navigationItem.title = @"Menu";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setFont:fontHelveticaBold15];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    }
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"My Fav Meals";
            cell.imageView.image =[UIImage imageNamed:@"iconNumberOfFAVMeals.png"];
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"My Restaurants";
            cell.imageView.image =[UIImage imageNamed:@"iconNumberOfRestourants.png"];
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"Nearby Restaurants";
            cell.imageView.image =[UIImage imageNamed:@"iconNumberOfRestourants.png"];
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"Top Restaurants";
            cell.imageView.image =[UIImage imageNamed:@"iconNumberOfRestourants.png"];
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"Settings";
            cell.imageView.image =[UIImage imageNamed:@"iconNumberOfRestourants.png"];
        }
            break;
        default:
            break;
    }
	// Configure the cell.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row)
    {
        case 0:
        {
            MealListController *mealListController = [[MealListController alloc] initWithNibName:@"MealListController" bundle:nil];
            mealListController.isFavMeal = TRUE;
            [self.navigationController pushViewController:mealListController animated:TRUE];
            [mealListController release];
            break;    
        }
        case 1:
        {
            MyRestaurantsListViewController *controller = [[MyRestaurantsListViewController alloc]initWithNibName:@"MyRestaurantsListViewController" bundle:nil];
            controller.type = TYPE_MY_RESTAURANT;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            break;            
        }

        case 2:
        {
            MyRestaurantsListViewController *controller = [[MyRestaurantsListViewController alloc]initWithNibName:@"MyRestaurantsListViewController" bundle:nil];
            controller.type = TYPE_NEARBY_RESTAURANT;            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            break;            
        }
            
        case 3:
        {
            MyRestaurantsListViewController *controller = [[MyRestaurantsListViewController alloc]initWithNibName:@"MyRestaurantsListViewController" bundle:nil];
            controller.type = TYPE_TOP_RESTAURANT;                        
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            break;            
        }

        case 4:
        {
            SettingsViewController *controller = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            break;            
        }

        default:
            break;
    }
}


#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
