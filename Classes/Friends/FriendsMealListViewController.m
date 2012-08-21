//
//  FriendsMealListViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/14/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FriendsMealListViewController.h"
#import "FriendInfoCell.h"
#import "MealInfoCell.h"
#import "AddFriendViewController.h"
#import "FriendAndRequestListViewController.h"
#import "FriendMealInfoViewController.h"
#import "UserMealInfo.h"
#import "RestaurantViewController.h"
#import "RatingView.h"
#import "UserRestaurantInfo.h"
#import "MealMapController.h"


@interface FriendsMealListViewController ()

- (void)startIconDownloadWithLink:(NSString *)imageDwldURLStr forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation FriendsMealListViewController

@synthesize recentMealArr;
@synthesize friendMealListArr;
@synthesize filteredMealArr;
@synthesize filteredFriendMealArr;
@synthesize searchTextField;
@synthesize friendsTable;
@synthesize imageDownloadsInProgress;
@synthesize btnUser;


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
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];

    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    self.friendsTable.dataSource = nil;
    self.friendsTable.delegate = nil;
    self.friendsTable = nil;
    
    self.filteredMealArr=nil;
    self.friendMealListArr=nil;
    self.btnUser = nil;
    
    [imageDownloadsInProgress release];
    [searchTextField release];
    [friendsTable release];    
    [recentMealArr release];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBackground.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    self.navigationItem.title = @"Friends";

    //set right navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem];
	[rightItem release];
    
    //set left navigation item
    self.btnUser = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnUser setFrame:CGRectMake(0, 0, 55, 30)];
    [self.btnUser setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [self.btnUser setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [self.btnUser setImage:[UIImage imageNamed:@"user_group.png"] forState:UIControlStateNormal];    
    self.btnUser.titleEdgeInsets = UIEdgeInsetsMake(0, 0 , 10, 0);
    self.btnUser.imageEdgeInsets = UIEdgeInsetsMake(0, 0 , 0, 5);
    //[self.btnUser setTitle:@"0" forState:UIControlStateNormal];
    [self.btnUser.titleLabel setTextColor:[UIColor whiteColor]];
    [self.btnUser addTarget:self action:@selector(listFriendClicked) forControlEvents:UIControlEventTouchUpInside];    
    [self.btnUser.titleLabel setFont:fontHelveticaBold10];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnUser];
    [self.navigationItem setLeftBarButtonItem:leftItem];
	[leftItem release];     

    self.filteredMealArr = [NSMutableArray array];
    self.filteredFriendMealArr =  [NSMutableArray array];

    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.searchTextField setText:@""];
    searchBarSelected = FALSE;
    [self.filteredMealArr removeAllObjects];
    [self.filteredFriendMealArr removeAllObjects];
    
}

-(void)viewDidAppear:(BOOL)animated {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRecentMealList) toTarget:self withObject:nil]; 
}

-(void)viewWillDisappear:(BOOL)animated {
    if([self.searchTextField isFirstResponder])
        [self.searchTextField resignFirstResponder];
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Server Communication

-(void)prepareRecentMealList {
    DigitalPlateAppDelegate *appDel = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(![appDel checkInternetConnectivity])
        return;

    
    NSMutableDictionary *_dictionary = [[NSMutableDictionary alloc] init];
    [_dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];
    NSMutableArray *requestArray = [RequestHandler getFriendRequestList:_dictionary];
    
    if([requestArray count]==1 && [[requestArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        [requestArray removeAllObjects];
    }
    [_dictionary release];
    
    if([requestArray count]>0) {
        //self.btnUser.titleEdgeInsets = UIEdgeInsetsMake(0, 0 , 10, 0);
        [self.btnUser.titleLabel setText:[NSString stringWithFormat:@"%d",[requestArray count]]];
    }
    
    
    //  Get Friends, currently having meal
    _dictionary = [[NSMutableDictionary alloc] init];
    //[_dictionary setObject:@"4" forKey:@"User_ID"];    
    [_dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];   
    self.friendMealListArr = [RequestHandler getFriendMealList:_dictionary];
    
    if([self.friendMealListArr count]==1 && [[self.friendMealListArr objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        [self.friendMealListArr removeAllObjects];
    }
    [_dictionary release];

    //  Get latedt Meals by friends
    _dictionary = [[NSMutableDictionary alloc] init];
    //[_dictionary setObject:@"4" forKey:@"User_ID"];
    [_dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];    
    self.recentMealArr = [RequestHandler getRecentMealList:_dictionary];
    
    if([self.recentMealArr count]==1 && [[self.recentMealArr objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        [self.recentMealArr removeAllObjects];
    }    
    [_dictionary release];
    
    [friendsTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [appDel stopActivityIndicator];
}

#pragma mark -
#pragma mark Bar Button Actions

-(void)listFriendClicked {
    
    FriendAndRequestListViewController *controller = [[FriendAndRequestListViewController alloc]initWithNibName:@"FriendAndRequestListViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)addClicked {
    
    AddFriendViewController *controller = [[AddFriendViewController alloc]initWithNibName:@"AddFriendViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    int rowheight = 100;
	
	return rowheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    int rowheight;
    
    if(searchBarSelected) {
        
        if (section==0) {
            
            if([self.filteredFriendMealArr count] > 0)
                rowheight = 27;
            else 
                rowheight = 0;
        }
        
        else {
            if([self.filteredMealArr count] > 0 )
                rowheight = 27;
            else 
                rowheight = 0;
        }
    }
    else {
        if (section==0) {
            if([self.friendMealListArr count] > 0)
                rowheight = 27;
            else 
                rowheight = 0;
        }
        
        else {
            if([self.recentMealArr count] > 0 )
                rowheight = 27;
            else 
                rowheight = 0;
        }
    }
	return rowheight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
	UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 27)] autorelease];
	label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBackground.png"]];
	label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = fontHelveticaBold14;    

    
	switch (section)  {
            
		case 0:
			label.text= @"Currently having meal";
			break;
		case 1:
			label.text= @"Latest meals by friends";
			break;
        default:
			break;
	}
	return label;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {

    int rows;
    
    if (section==0) {
        
        if (searchBarSelected) {
            rows=[self.filteredFriendMealArr count];
        }
        
        else {
            rows=[self.friendMealListArr count];
        }
    }
    
    else {
        if (searchBarSelected) {
            rows =[self.filteredMealArr count];
        }
        else {
            rows = [self.recentMealArr count];
        }
        
    }
    return rows;	
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        static NSString *CellIdentifier = @"FriendInfoCell";
        static NSString *CellNib = @"FriendInfoCell";
        
		FriendInfoCell *cell = (FriendInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
			cell = (FriendInfoCell *)[nib objectAtIndex:0];
		}
        
		UserRestaurantInfo *userRest;
        if (searchBarSelected) {
            userRest = [self.filteredFriendMealArr objectAtIndex:indexPath.row];
        }
        else {
            userRest = [self.friendMealListArr objectAtIndex:indexPath.row];
        }
        
        cell.locationButton.tag = indexPath.row;
        [cell.locationButton addTarget:self action:@selector(gotoLocationClicked:) forControlEvents:UIControlEventTouchUpInside];

		// perform additional custom work...
        cell.friendImage.image = [UIImage imageNamed:@"User.png"];
        cell.friendNameLabel.text =[NSString stringWithFormat:@"%@ %@",userRest.userInfo.firstName,userRest.userInfo.lastName];
        cell.restaurantNameLabel.text = userRest.restaurant.resturantName;
        cell.restaurantAddLabel.text =userRest.restaurant.address;
        
        cell.friendImage.layer.masksToBounds = YES;
        cell.friendImage.layer.cornerRadius = 7.0;
        cell.friendImage.layer.borderWidth = 1.0;
        cell.friendImage.layer.borderColor = [[UIColor grayColor] CGColor];

        
//        cell.timeLabel.text = @"12 min ago";
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
		
		return cell;
   
    }
    
    else {
        static NSString *CellIdentifier = @"MealInfoCell";
        static NSString *CellNib = @"MealInfoCell";
        
		MealInfoCell *cell = (MealInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
			cell = (MealInfoCell *)[nib objectAtIndex:0];
		}
        
        UserMealInfo *userMeal;
        if (searchBarSelected) {
            userMeal = [self.filteredMealArr objectAtIndex:indexPath.row];
        }
        else {
            userMeal = [self.recentMealArr objectAtIndex:indexPath.row];
        }
        
        
		// perform additional custom work...
        //cell.mealImage.image = [UIImage imageNamed:@"mealSample"];
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!userMeal.mealInfo.mealImage)
        {
            if (self.friendsTable.dragging == NO && self.friendsTable.decelerating == NO)
            {
                [self startIconDownloadWithLink:userMeal.mealInfo.image forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.mealImage.image = [UIImage imageNamed:@"mealSample.png"];                
        }
        else
        {
            cell.mealImage.image = userMeal.mealInfo.mealImage;
        }
        
        cell.mealImage.layer.masksToBounds = YES;
        cell.mealImage.layer.cornerRadius = 7.0;
        cell.mealImage.layer.borderWidth = 1.0;
        cell.mealImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
        cell.mealNameLabel.text = userMeal.mealInfo.meal_Name;
        
        //cell.mealDescriptionLabel.text = userMeal.mealInfo.meal_Info;
        NSString *description = userMeal.mealInfo.meal_Info;
        CGSize size = [description sizeWithFont:cell.mealDescriptionLabel.font constrainedToSize:CGSizeMake(173, 480.0) lineBreakMode:UILineBreakModeWordWrap];
        [cell.mealDescriptionLabel setNumberOfLines:3];        
        [cell.mealDescriptionLabel setFrame:CGRectMake(74, 22, 173, (size.height)>50?50:size.height)];
        [cell.mealDescriptionLabel setText:description];
        
        
        RatingView *ratingView = [[RatingView alloc]initWithFrame:CGRectMake(75, 65, 110, 30)];
        ratingView.backgroundColor = [UIColor clearColor];
        ratingView.userInteractionEnabled=FALSE;

        [ratingView setRating:[userMeal.mealInfo.mealRating intValue]]; 
        [cell addSubview:ratingView];
        [ratingView release];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
		
		return cell;

    }
}

#pragma mark -
#pragma mark Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)
    {
        RestaurantViewController *_restaurantController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
        
     //   _restaurantController.userMealInfo = ;
       
       // FriendMealInfoViewController *controller = [[FriendMealInfoViewController alloc]initWithNibName:@"FriendMealInfoViewController" bundle:nil];
        if (searchBarSelected)
        {
            _restaurantController.userMealInfo = [self.filteredFriendMealArr objectAtIndex:indexPath.row];
        }
        else
        {
            _restaurantController.userMealInfo = [self.friendMealListArr objectAtIndex:indexPath.row];
        }
        [self.navigationController pushViewController:_restaurantController animated:TRUE];
        [_restaurantController release];

       // [self.navigationController pushViewController:controller animated:YES];
       // [controller release];
    }
    else if(indexPath.section == 1)
    {
        FriendMealInfoViewController *controller = [[FriendMealInfoViewController alloc]initWithNibName:@"FriendMealInfoViewController" bundle:nil];
        if (searchBarSelected)
        {
            controller.meal = [self.filteredMealArr objectAtIndex:indexPath.row];
        }
        else
        {
            controller.meal = [self.recentMealArr objectAtIndex:indexPath.row];
        }
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark -
#pragma mark IB Outlet Actions

-(IBAction)gotoLocationClicked:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    int index = btn.tag;
    MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
    UserMealInfo *obj = [[UserMealInfo alloc]init];
    if (searchBarSelected)
    {
        UserRestaurantInfo *usrRest = [self.filteredFriendMealArr objectAtIndex:index];
        obj.restaurant.address = usrRest.restaurant.address;
        obj.restaurant.resturantName = usrRest.restaurant.resturantName;
        obj.restaurant.latitude=usrRest.restaurant.latitude;
        obj.restaurant.longitude=usrRest.restaurant.longitude;
        
    }
    else
    {
        UserRestaurantInfo *usrRest = [self.friendMealListArr objectAtIndex:index];
        obj.restaurant.address = usrRest.restaurant.address;
        obj.restaurant.resturantName = usrRest.restaurant.resturantName;
        obj.restaurant.latitude=usrRest.restaurant.latitude;
        obj.restaurant.longitude=usrRest.restaurant.longitude;
    }
    mealMapController.userMealInfo = obj;
    [self.navigationController pushViewController:mealMapController animated:TRUE];
    [obj release];
    [mealMapController release];
}

#pragma mark -
#pragma mark search methods

- (IBAction)searchUsingContentsOfTextField:(id)sender {
    
    searchBarSelected = TRUE;    
    [self.filteredMealArr removeAllObjects];
    [self.filteredFriendMealArr removeAllObjects];
    NSString *searchString= ((UITextField *)sender).text;
    
    for (UserRestaurantInfo *userRest in self.friendMealListArr)
	{
        NSString *str = [NSString stringWithFormat:@"%@ %@",userRest.userInfo.firstName,userRest.userInfo.lastName];
		if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound)
        {
            [self.filteredFriendMealArr addObject:userRest];
        }
        
	}
    
    for (UserMealInfo *userMeal in self.recentMealArr)
	{
        NSString *str = userMeal.mealInfo.meal_Name;
		if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound)
        {
            [self.filteredMealArr addObject:userMeal];
        }
        
	}
    if ([((UITextField *)sender).text length]==0) {
        searchBarSelected = FALSE;
    }
    [friendsTable reloadData];
}


#pragma mark -
#pragma mark Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    searchBarSelected = FALSE;
    return TRUE;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    searchBarSelected = FALSE;
    [friendsTable reloadData];
    [textField resignFirstResponder];
    return TRUE;
}



#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownloadWithLink:(NSString *)imageDwldURLStr forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (iconDownloader == nil)  {
        iconDownloader = [[IconDownloader alloc] init];        
        iconDownloader.imageDownloadURLStr = imageDwldURLStr;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}


// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.recentMealArr count] > 0)
    {
        NSArray *visiblePaths = [self.friendsTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
//            if(indexPath.section == 1) {
                UserMealInfo *mealInfo = [self.recentMealArr objectAtIndex:indexPath.row];
                
                if (!mealInfo.mealInfo.mealImage) // avoid the app icon download if the app already has an icon
                {
                    NSString *finalURL = mealInfo.mealInfo.image;
                    [self startIconDownloadWithLink:finalURL forIndexPath:indexPath];
                }                
//            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    if(imageDownloadsInProgress!=nil) {
        IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
        if (iconDownloader != nil)
        {        
            //        if(indexPath.section == 1) {
            MealInfoCell *cell = (MealInfoCell*)[self.friendsTable cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            
            // Display the newly loaded image
            cell.mealImage.image = iconDownloader.iconImage;
            
            UserMealInfo *mealInfo = [self.recentMealArr objectAtIndex:indexPath.row];
            mealInfo.mealInfo.mealImage = iconDownloader.iconImage;
            //        }
        }        
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
