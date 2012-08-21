//
//  FriendsFullProfileViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/16/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FriendsFullProfileViewController.h"
#import "MealListCell.h"
#import "LatestMealCell.h"
#import "UserMealInfo.h"
#import "RatingView.h"
#import "MealMapController.h"

@interface FriendsFullProfileViewController ()
    - (void)startIconDownloadWithLink:(NSString *)imageDwldURLStr forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation FriendsFullProfileViewController

@synthesize friendProfile;
@synthesize favMealList;
@synthesize filteredMealList;
@synthesize searchTextField;
@synthesize friendsTable;
@synthesize imageDownloadsInProgress;

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

-(void)dealloc {
    self.friendsTable.dataSource = nil;
    self.friendsTable.delegate = nil;
    
    [imageDownloadsInProgress release];
    
    self.favMealList = nil;
    self.filteredMealList = nil;
    
    [searchTextField release];
    [friendsTable release];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    //set right navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Rem" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(removeClicked) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem];
	[rightItem release];
    
    //set left navigation item
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 55, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarBtnBackNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarBtnBackPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@" Back" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftItem];
	[leftItem release];
    
   
    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated 
{
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.filteredMealList = [NSMutableArray array];
    
    [self.searchTextField setText:@""];
    searchBarSelected = FALSE;
    
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

-(void)prepareRequestDirectory {
    
    DigitalPlateAppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    if(![appDel checkInternetConnectivity])
        return;

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:friendProfile.UserID forKey:@"User_ID"];
    //[dict setObject:@"12" forKey:@"User_ID"];    
    
    self.favMealList = [RequestHandler getFavMealList:dict];
    [dict release];

    if([self.favMealList count] > 0 && [[self.favMealList objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_MEAL_NOTFOUND delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [self.favMealList removeAllObjects];
    }    
    
    [friendsTable reloadData];
    [appDel stopActivityIndicator];
}


-(void)removeClicked {
    DigitalPlateAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    if(![appDel checkInternetConnectivity])
        return;
    
    [appDel startActivityIndicator];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];
    [dictionary setObject:friendProfile.UserID forKey:@"Friend_ID"];
    
    NSArray *arr =[RequestHandler removeFriend:dictionary];
    NSString *str = [[arr objectAtIndex:0] valueForKey:@"Status"];
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Digital Plate" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    [appDel stopActivityIndicator];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark Bar Button Actions

-(void)backButtonPressed:(id)sender {    
    //DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark Rating View Delegate

-(void)changedRating:(int)rating {
	NSLog(@"Rating :%d",rating);
    //    self.userMealInfo.mealRating = [NSString stringWithFormat:@"%d",rating];
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int rowheight;
    if (indexPath.section==0) {
        rowheight = 60;
    }
    else {
        rowheight = 100;
    }
	
	return rowheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    int rowheight;

    if (section==1) {
        
        if(searchBarSelected) {
            if([self.filteredMealList count] > 0) {
                rowheight = 27;
            }
            else {
                rowheight = 0;
            }
        }
        else {
            if([self.favMealList count] > 0) {
                rowheight = 27;
            }
            else {
                rowheight = 0;
            }
        }
    }
	else 
        return 0;
    
	return rowheight;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 27)] autorelease];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBackground.png"]];    
//	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = fontHelveticaBold14;    

	switch (section) 
	{
		case 0:
			label.text= @"";
			break;
		case 1:
			label.text= @"Favorited Meals";
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section==0)
    {
        return 1;
    }
    else
    {
        if (searchBarSelected)
        {
            return [self.filteredMealList count];
        }
        else
        {
            return [favMealList count];	
        }
        
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *CellIdentifier = @"LatestMealCell";
        static NSString *CellNib = @"LatestMealCell";
        
		LatestMealCell *cell = (LatestMealCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
		if (cell == nil)  {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
			cell = (LatestMealCell *)[nib objectAtIndex:0];
		}
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        
        if (friendProfile.firstName!=NULL && friendProfile.lastName != NULL) {
            cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@",friendProfile.firstName,friendProfile.lastName];
        }
		else if(friendProfile.firstName!=NULL) {
            cell.friendNameLabel.text =[NSString stringWithFormat:@"%@",friendProfile.firstName];
        }
        cell.mealNameLabel.text = friendProfile.lastName;
        
        if (friendProfile.numOfFriends != NULL) {
            cell.numOfFriendRequest.text = friendProfile.numOfFriends;
        }
        
        if (friendProfile.numOfFavMeals!=NULL) {
            cell.numOfFavMeal.text = friendProfile.numOfFavMeals;
        }
        
        if (friendProfile.numberOfRestaurant!=NULL) {
            cell.numberOfRestaurant.text = friendProfile.numberOfRestaurant;
        }
        
        cell.mealNameLabel.text = friendProfile.lastMeal;
        
        cell.friendImage.image = [UIImage imageNamed:@"User.png"];
        cell.friendImage.layer.masksToBounds = YES;
        cell.friendImage.layer.cornerRadius = 7.0;
        cell.friendImage.layer.borderWidth = 1.0;
        cell.friendImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
		return cell;
        
    }
    else
    {
        
        static NSString *CellIdentifier = @"MealListCell";
        static NSString *CellNib = @"MealListCell";
        
        MealListCell *cell = (MealListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)  {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
            cell = (MealListCell *)[nib objectAtIndex:0];
            [cell.mapViewButton addTarget:self action:@selector(openMap:) forControlEvents:UIControlEventTouchUpInside];        
        }
        
        //UserMealInfo *usermealInfo = [self.arrayMeals objectAtIndex:indexPath.row];
        UserMealInfo *usermealInfo = nil;
        
        if (searchBarSelected) {
            usermealInfo = [self.filteredMealList objectAtIndex:indexPath.row];
        }
        else {
            usermealInfo = [self.favMealList objectAtIndex:indexPath.row];
        }
        
        for (UIView *rattingView in [cell.contentView subviews]) {
            NSLog(@"rattingView:%@",rattingView);
            if([rattingView isKindOfClass:[RatingView class]]) {
                [rattingView removeFromSuperview];
            }
        }
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!usermealInfo.mealInfo.mealImage)
        {
            if (self.friendsTable.dragging == NO && self.friendsTable.decelerating == NO)
            {
                [self startIconDownloadWithLink:usermealInfo.mealInfo.image forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.mealImage.image = [UIImage imageNamed:@"mealSample.png"];                
        }
        else
        {
            cell.mealImage.image = usermealInfo.mealInfo.mealImage;
        }
        
        
        //    cell.mealImage.image = [UIImage imageNamed:@"mealSample"];
        cell.mealImage.layer.masksToBounds = YES;
        cell.mealImage.layer.cornerRadius = 7.0;
        cell.mealImage.layer.borderWidth = 1.0;
        cell.mealImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
        cell.mealNameLabel.text = usermealInfo.mealInfo.meal_Name;
        cell.mealDescriptionLabel.text = usermealInfo.mealInfo.meal_Info;
        
        RatingView *ratingView = [[RatingView alloc] initWithFrame:CGRectMake(74, 70, 80, 22)];
        [ratingView setUserInteractionEnabled:FALSE]; 
        [ratingView setBackgroundColor:[UIColor clearColor]];        
        [ratingView setDelegate:self];  
        [ratingView setRating:[usermealInfo.mealInfo.mealRating intValue]];    
        [cell.contentView addSubview:ratingView];
        [ratingView release];  
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }
}

#pragma mark -
#pragma mark Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (indexPath.section==1)
     {
     FriendMealInfoViewController *controller = [[FriendMealInfoViewController alloc]initWithNibName:@"FriendMealInfoViewController" bundle:nil];
     [self.navigationController pushViewController:controller animated:YES];
     [controller release];
     }
     */
}

-(void)openMap:(id)sender{
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.friendsTable indexPathForCell:clickedCell];
    
    MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
    mealMapController.userMealInfo = [self.favMealList objectAtIndex:clickedButtonPath.row];
    [self.navigationController pushViewController:mealMapController animated:TRUE];
    [mealMapController release];
}

#pragma mark -
#pragma mark search methods

- (IBAction)searchUsingContentsOfTextField:(id)sender {
    
    searchBarSelected = TRUE;    
    [self.filteredMealList removeAllObjects];
    NSString *searchString= ((UITextField *)sender).text;
    
    for (UserMealInfo *meal in self.favMealList) {
        NSString *str = meal.mealInfo.meal_Name;
		if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound)
        {
            [self.filteredMealList addObject:meal];
        }
        
	}
    
   
    if ([((UITextField *)sender).text length]==0) {
        searchBarSelected = FALSE;
    }
    [friendsTable reloadData];
}

#pragma mark -
#pragma mark Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    searchBarSelected = FALSE;
    return TRUE;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
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
    if ([self.favMealList count] > 0) {
        
        NSArray *visiblePaths = [self.friendsTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if(indexPath.section == 1) {
                
                UserMealInfo *mealInfo = [self.favMealList objectAtIndex:indexPath.row];
                
                if (!mealInfo.mealInfo.mealImage) // avoid the app icon download if the app already has an icon
                {
                    NSString *finalURL = mealInfo.mealInfo.image;
                    [self startIconDownloadWithLink:finalURL forIndexPath:indexPath];
                }                
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath {
    
    if(imageDownloadsInProgress != nil) {
        IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
        
        if (iconDownloader != nil) {
            MealListCell *cell = (MealListCell*)[self.friendsTable cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            // Display the newly loaded image
            cell.mealImage.image = iconDownloader.iconImage;
        }
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}
@end
