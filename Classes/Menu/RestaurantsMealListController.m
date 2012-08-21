//
//  RestaurantsMealListController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/17/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "RestaurantsMealListController.h"
#import "RestaurantCell.h"
#import "MealListCell.h"
#import "UserMealInfo.h"
#import "MealMapController.h"

@interface RestaurantsMealListController ()
    - (void)startIconDownloadWithLink:(NSString *)imageDwldURLStr forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RestaurantsMealListController

@synthesize imageDownloadsInProgress;
@synthesize restaurant;
@synthesize arrayRestaurantMeals;
@synthesize searchTextField;
@synthesize restaurantTable;
@synthesize filterredRestaurantMeals;


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

- (void)dealloc {
    
    self.restaurantTable.delegate = nil;
    self.restaurantTable.dataSource = nil;
    
    [imageDownloadsInProgress release];

    self.searchTextField = nil;
    self.restaurantTable = nil;
    
    self.restaurant = nil;
    self.arrayRestaurantMeals = nil;
    self.filterredRestaurantMeals = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    
    //set left navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.arrayRestaurantMeals = [NSMutableArray array];
    self.filterredRestaurantMeals = [NSMutableArray array];
    [self.searchTextField setText:@""];
}

-(void)viewDidAppear:(BOOL)animated {
    [NSThread detachNewThreadSelector:@selector(getMealList) toTarget:self withObject:nil];    
}

-(void) viewWillDisappear:(BOOL)animated {
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Bar Button Actions


-(void)backButtonPressed:(id)sender {    
    //    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)openMap:(id)sender{
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.restaurantTable indexPathForCell:clickedCell];
    
    if(clickedButtonPath.section == 0) {
        
        MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
        UserMealInfo *obj = [[UserMealInfo alloc]init];
        obj.restaurant.restaurantID = restaurant.restaurantID;    
        obj.restaurant.resturantName = restaurant.resturantName;
        obj.restaurant.address = restaurant.address;    
        obj.restaurant.latitude = restaurant.latitude;
        obj.restaurant.longitude = restaurant.longitude;
        obj.restaurant.email = restaurant.email;
        obj.restaurant.website = restaurant.website;
        obj.restaurant.phoneNumber = restaurant.phoneNumber;
        obj.restaurant.favoriteMeals = restaurant.favoriteMeals;    
        
        mealMapController.userMealInfo = obj;
        [self.navigationController pushViewController:mealMapController animated:TRUE];
        [mealMapController release];
    }
    else {
        MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
        if(searchBarSelected) {
            mealMapController.userMealInfo = [self.filterredRestaurantMeals objectAtIndex:clickedButtonPath.row];        
        }
        else {
            mealMapController.userMealInfo = [self.arrayRestaurantMeals objectAtIndex:clickedButtonPath.row];        
        }
        [self.navigationController pushViewController:mealMapController animated:TRUE];
        [mealMapController release];
    }    
}

#pragma mark -
#pragma mark Server Communication

-(void)getMealList {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 
}

-(void)prepareRequestDirectory {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
    [dt setObject:restaurant.restaurantID forKey:@"Restaurant_ID"];
    
    //Prepare Request
    if(![delegate checkInternetConnectivity])
        return;
    self.arrayRestaurantMeals = [RequestHandler getRestaurantMealList:dt];        
    
    if([self.arrayRestaurantMeals count] > 0 && [[self.arrayRestaurantMeals objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_NO_MEAL_FOUND delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [delegate stopActivityIndicator];        
    }
    else {
        [delegate stopActivityIndicator];
        
//        for (UserMealInfo *_mealInfo in self.arrayMeals) {
//            if(![self.distictDates containsObject:_mealInfo.mealInfo.created]) {
//                [self.distictDates addObject:_mealInfo.mealInfo.created];
//            }
//        }
//        
//        for (NSString *strDates in self.distictDates) {
//            NSMutableArray *_arrayMeals = [[NSMutableArray alloc] init];
//            for (UserMealInfo *_mealInfo in self.arrayMeals) {
//                if([strDates isEqualToString:_mealInfo.mealInfo.created]) {
//                    [_arrayMeals addObject:_mealInfo];
//                }
//            }
//            [self.arrayDistMeals addObject:_arrayMeals];
//        }
        
        [self.restaurantTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //[self.mealTable reloadData];
    }
    [dt release];
}

#pragma mark -
#pragma mark Rating View Delegates

-(void)changedRating:(int)rating {
	NSLog(@"Rating :%d",rating);
    //    self.userMealInfo.mealRating = [NSString stringWithFormat:@"%d",rating];
}


#pragma mark -
#pragma mark search methods

- (IBAction)searchUsingContentsOfTextField:(id)sender {
    
    searchBarSelected = TRUE;    
    [self.filterredRestaurantMeals removeAllObjects];
    NSString *searchString= ((UITextField *)sender).text;
    
    for (UserMealInfo *usermealInfo in self.arrayRestaurantMeals) {
        
        NSString *str = [NSString stringWithFormat:@"%@",usermealInfo.mealInfo.meal_Name];
        if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound) {
            [self.filterredRestaurantMeals addObject:usermealInfo];
        }
    }
    
    if ([((UITextField *)sender).text length]==0) {
        searchBarSelected = FALSE;
    }
    [self.restaurantTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark Text Field Delegates


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    searchBarSelected = FALSE;
    return TRUE;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    searchBarSelected = FALSE;
    [self.restaurantTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];     
    [textField resignFirstResponder];
    return TRUE;
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowheight;
    if (indexPath.section==0) {
        rowheight = 80;
    }
    else {
        rowheight = 105;
    }
    
	return rowheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        return 0;
    }
    else {
        if(searchBarSelected) {
            if([self.filterredRestaurantMeals count] == 0) {
                return 0;
            }
            else {
                return 27;
            }
        }
        else {
            if([self.arrayRestaurantMeals count] == 0) {
                return 0;
            }
            else {
                return 27;
            }            
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        return nil;
    }
    else {
        UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 27)] autorelease];
        label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBackground.png"]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = fontHelveticaBold14;    
        label.text = @"Meals";
        return label;	
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    
    if (section==0)  {
        return 1;
    }
    else {
        if(searchBarSelected) {
            return [self.filterredRestaurantMeals count];
        }
        else {
            return [self.arrayRestaurantMeals count];	            
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)
    {
        static NSString *CellIdentifier = @"RestaurantCell";
        static NSString *CellNib = @"RestaurantCell";
        
		RestaurantCell *cell = (RestaurantCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
			cell = (RestaurantCell *)[nib objectAtIndex:0];
            [cell.mapViewButton addTarget:self action:@selector(openMap:) forControlEvents:UIControlEventTouchUpInside];    
		}
        
		// perform additional custom work...
        cell.restaurantNameLabel.text = self.restaurant.resturantName;
        cell.restaurantAddLabel.text = self.restaurant.address;
        cell.numOfFavMeal.text = self.restaurant.favoriteMeals;
      	cell.selectionStyle = UITableViewCellSelectionStyleNone;	
		
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
        if(searchBarSelected) {
            usermealInfo = [self.filterredRestaurantMeals objectAtIndex:indexPath.row];            
        }
        else {
            usermealInfo = [self.arrayRestaurantMeals objectAtIndex:indexPath.row];            
        }

        
        for (UIView *rattingView in [cell.contentView subviews]) {
            NSLog(@"rattingView:%@",rattingView);
            if([rattingView isKindOfClass:[RatingView class]]) {
                [rattingView removeFromSuperview];
            }
        }
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!usermealInfo.mealInfo.mealImage) {
            if (self.restaurantTable.dragging == NO && self.restaurantTable.decelerating == NO) {
                [self startIconDownloadWithLink:usermealInfo.mealInfo.image forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.mealImage.image = [UIImage imageNamed:@"mealSample.png"];                
        }
        else {
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //   No Detailing
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownloadWithLink:(NSString *)imageDwldURLStr forIndexPath:(NSIndexPath *)indexPath {
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
    if ([self.arrayRestaurantMeals count] > 0)
    {
        NSArray *visiblePaths = [self.restaurantTable indexPathsForVisibleRows];
        
        for (NSIndexPath *indexPath in visiblePaths) {
            UserMealInfo *mealInfo = [self.arrayRestaurantMeals objectAtIndex:indexPath.row];
            
            if (!mealInfo.mealInfo.mealImage) // avoid the app icon download if the app already has an icon
            {
                NSString *finalURL = mealInfo.mealInfo.image;
                [self startIconDownloadWithLink:finalURL forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    if(imageDownloadsInProgress != nil) {
        IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
        if (iconDownloader != nil) {
            MealListCell *cell = (MealListCell*)[self.restaurantTable cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            
            // Display the newly loaded image
            cell.mealImage.image = iconDownloader.iconImage;
            
            UserMealInfo *mealInfo = [self.arrayRestaurantMeals objectAtIndex:indexPath.row];
            mealInfo.mealInfo.mealImage = iconDownloader.iconImage;
        }        
    }
}



#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
