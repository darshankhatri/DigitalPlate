//
//  MealListController.m
//  DigitalPlate
//
//  Created by iDroid on 21/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MealListController.h"
#import "MealListCell.h"
#import "UserMealInfo.h"
#import "MealMapController.h"
#import "MealDetailController.h"

@interface MealListController ()

- (void)startIconDownloadWithLink:(NSString *)imageDwldURLStr forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MealListController

@synthesize imageDownloadsInProgress;

@synthesize searchTextField;
@synthesize mealTable;   
@synthesize arrayMeals;
@synthesize mealDetailController;
@synthesize filteredFriendMealArr;
@synthesize distictDates;
@synthesize arrayDistMeals;
@synthesize strTodayDate;
@synthesize isFavMeal;

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
    self.mealTable.dataSource = nil;
    self.mealTable.delegate = nil;
    
    [imageDownloadsInProgress release];
    [searchTextField release];
    [mealTable release]; 
    [arrayMeals release];
    [mealDetailController release];
    [distictDates release];
    [arrayDistMeals release];
    [strTodayDate release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    if(isFavMeal) {
        self.navigationItem.title = @"Fav Meals";        
    }
    else {
        self.navigationItem.title = @"Meal List";        
    }

    //set right navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Sort" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(sortMeal:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //[self.navigationItem setRightBarButtonItem:rightItem];
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.strTodayDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"strTodayDate :%@",self.strTodayDate);
    
    self.filteredFriendMealArr = [[[NSMutableArray alloc]init] autorelease];
    self.distictDates = [[[NSMutableArray alloc]init] autorelease];
    self.arrayDistMeals = [[[NSMutableArray alloc]init] autorelease];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.filteredFriendMealArr removeAllObjects];
    [self.distictDates removeAllObjects];
    [self.arrayDistMeals removeAllObjects];
    [self.searchTextField setText:@""];
}

-(void)viewDidAppear:(BOOL)animated {
    [NSThread detachNewThreadSelector:@selector(getMealList) toTarget:self withObject:nil];    
}

-(void)viewWillDisappear:(BOOL)animated {
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark View lifecycle

-(void)sortMeal:(id)sender {
    
}

-(void)backButtonPressed:(id)sender {    
//    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}


#pragma mark -
#pragma mark Server communication

-(void)getMealList {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 
}

-(void)prepareRequestDirectory {
    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    if(![delegate checkInternetConnectivity])
    {
        NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
        [dt setObject:delegate.userInfo.UserID forKey:@"User_ID"];
        
        database = [[DAL alloc] init];
        NSString *query =[NSString stringWithFormat:@"SELECT * FROM mealDetails"];
        NSDictionary *databaseValue = [database executeDataSet:query];
        
        NSArray *tempArray = [databaseValue allKeys];
        for (int i = 1; i <= [tempArray count]; i++) {
            
            NSString *databaseKey = [NSString stringWithFormat:@"Table %d",i];
            NSMutableDictionary *values =  [databaseValue objectForKey:databaseKey];
            NSMutableDictionary *Meal_OBJ = [[NSMutableDictionary alloc] init];
            [Meal_OBJ setValue:[values valueForKey:@"Created"] forKey:@"Created"];
            [Meal_OBJ setValue:[values valueForKey:@"Image"] forKey:@"Image"];
            [Meal_OBJ setValue:[values valueForKey:@"Info"] forKey:@"Info"];
            [Meal_OBJ setValue:[values valueForKey:@"Is_Favorite"] forKey:@"Is_Favorite"];
            [Meal_OBJ setValue:[values valueForKey:@"Meal_ID"] forKey:@"Meal_ID"];
            [Meal_OBJ setValue:[values valueForKey:@"Meal_Name"] forKey:@"Meal_Name"];
            [Meal_OBJ setValue:[values valueForKey:@"Ratting"] forKey:@"Ratting"];
            
            
            
            NSMutableDictionary *Restaurant_OBJ = [[NSMutableDictionary alloc] init];
            [Restaurant_OBJ setValue:[values valueForKey:@"Address"] forKey:@"Address"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Email"] forKey:@"Email"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Lat"] forKey:@"Lat"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Long"] forKey:@"Long"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Number_of_favourite_meal"] forKey:@"Number_of_favourite_meal"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Restaurant_ID"] forKey:@"Restaurant_ID"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Restaurant_Name"] forKey:@"Restaurant_Name"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Website_Detail"] forKey:@"Website_Detail"];
            
            
            
            
            NSMutableDictionary *entireDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:Meal_OBJ,@"Meal_OBJ",Restaurant_OBJ, @"Restaurant_OBJ", nil];
    
            UserMealInfo *userMealInfo = [[UserMealInfo alloc] initWithDictionary:entireDictionary];
            [returnArray addObject:userMealInfo];
            NSLog(@"%d      %@", i , returnArray);
            
            
        }
//        titleCell.text= [values valueForKey:@"alertName"];
//        dateCell.text = [values valueForKey:@"alertDate"];
//        statusCell.text = [values valueForKey:@"status"];

        if ([self.arrayMeals count]) {
            [self.arrayMeals removeAllObjects]; 
        }
        
        self.arrayMeals = returnArray;
        [self.arrayMeals  retain];
       
        NSLog(@"ArrayMeals:%@", self.arrayMeals);
        [returnArray release];
        //return;
    }
    else {
        NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
        [dt setObject:delegate.userInfo.UserID forKey:@"User_ID"];
        //[dt setObject:@"1" forKey:@"User_ID"];
        
        //Prepare Request
        if(isFavMeal) {
            self.arrayMeals = [RequestHandler getFavMealList:dt];
        }
        else {
            self.arrayMeals = [RequestHandler getUserMealList:dt];        
        }    
    }
        
        if([self.arrayMeals count] > 0 && [[self.arrayMeals objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_NO_MEAL_FOUND delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [delegate stopActivityIndicator];        
        }
        else {
            [delegate stopActivityIndicator];
             
            for (UserMealInfo *_mealInfo in self.arrayMeals) {
                if(![self.distictDates containsObject:_mealInfo.mealInfo.created]) {
                    [self.distictDates addObject:_mealInfo.mealInfo.created];
                }
            }
            
            for (NSString *strDates in self.distictDates) {
                NSMutableArray *_arrayMeals = [[NSMutableArray alloc] init];
                for (UserMealInfo *_mealInfo in self.arrayMeals) {
                    if([strDates isEqualToString:_mealInfo.mealInfo.created]) {
                        [_arrayMeals addObject:_mealInfo];
                    }
                }
                [self.arrayDistMeals addObject:_arrayMeals];
            }
            

    }

           
        [self.mealTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
//    [dt release];
}

#pragma mark -
#pragma TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	return 27;
    
    if(searchBarSelected) {
        if([[self.filteredFriendMealArr objectAtIndex:section] count] == 0) {
            return 0;
        }
        else {
            return 27;
        }
    }
    else {
        if([[self.arrayDistMeals objectAtIndex:section] count] == 0) {
            return 0;
        }
        else {
            return 27;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
	UILabel *label = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 27)] autorelease];
	//label.backgroundColor = [UIColor darkGrayColor];
    //label.backgroundColor = [UIColor brownColor];    
	label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBackground.png"]];
	label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = fontHelveticaBold14;    
    label.text = [[self.distictDates objectAtIndex:section] isEqualToString:self.strTodayDate] ? @"Today" : [self.distictDates objectAtIndex:section];
    label.text = [label.text stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    if (searchBarSelected) {
        if([[self.filteredFriendMealArr objectAtIndex:section] count] == 0) {
            label.text= @"";
        }
        else {
        }
    }
    else {
        if([[self.arrayDistMeals objectAtIndex:section] count] == 0) {
            label.text= @"";
        }
        else {

        }
    }
    
	return label;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return 1;
    return [self.distictDates count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.arrayMeals count];

    int rows;
    
    if (searchBarSelected) {
        rows=[[self.filteredFriendMealArr objectAtIndex:section] count];
    }
    else {
        rows=[[self.arrayDistMeals objectAtIndex:section] count];
    }
    return rows;	
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MealDetailController *_mealDetailController = [[MealDetailController alloc] initWithNibName:@"MealDetailController" bundle:nil];
    
    if (searchBarSelected) {
        _mealDetailController.userMealInfo = [[self.filteredFriendMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else {
        _mealDetailController.userMealInfo = [[self.arrayDistMeals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    //_mealDetailController.userMealInfo = [self.arrayMeals objectAtIndex:indexPath.row];
    
    self.mealDetailController = _mealDetailController;
    [self.navigationController pushViewController:self.mealDetailController animated:TRUE];
    [mealDetailController release];
}


// Customize the appearance of table view cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MealListCell";
    static NSString *CellNib = @"MealListCell";
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *)[[ UIApplication sharedApplication] delegate];
    MealListCell *cell = (MealListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)  {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (MealListCell *)[nib objectAtIndex:0];
        [cell.mapViewButton addTarget:self action:@selector(openMap:) forControlEvents:UIControlEventTouchUpInside];        
    }

    //UserMealInfo *usermealInfo = [self.arrayMeals objectAtIndex:indexPath.row];
    UserMealInfo *usermealInfo = nil;
    
    if (searchBarSelected) {
        usermealInfo = [[self.filteredFriendMealArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else {
        usermealInfo = [[self.arrayDistMeals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
        
    for (UIView *rattingView in [cell.contentView subviews]) {
        NSLog(@"rattingView:%@",rattingView);
        if([rattingView isKindOfClass:[RatingView class]]) {
            [rattingView removeFromSuperview];
        }
    }
    if (![ appDelegate checkInternetConnectivity]) {
        UserMealInfo *mealInfo = [[self.arrayDistMeals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if (!mealInfo.mealInfo.mealImage) // avoid the app icon download if the app already has an icon
        {
            NSString *imageName = [usermealInfo.mealInfo.image stringByReplacingOccurrencesOfString:@"http://" withString:@""];
            cell.mealImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageName]]; 
        }
        else {
            cell.mealImage.image = nil;
        }
        
    }
    else {
        cell.mealImage.image = nil;
    }

    // Only load cached images; defer new downloads until scrolling ends
    if (!usermealInfo.mealInfo.mealImage)
    {
        if (self.mealTable.dragging == NO && self.mealTable.decelerating == NO)
        {
            if (![ appDelegate checkInternetConnectivity]) {
                UserMealInfo *mealInfo = [[self.arrayDistMeals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                    
                if (!mealInfo.mealInfo.mealImage) // avoid the app icon download if the app already has an icon
                {
                    NSString *imageName = [usermealInfo.mealInfo.image stringByReplacingOccurrencesOfString:@"http://" withString:@""];
                    cell.mealImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageName]]; 
                }
            }

            else {
                [self startIconDownloadWithLink:usermealInfo.mealInfo.image forIndexPath:indexPath];
            }
            
        }
        // if a download is deferred or in progress, return a placeholder image
        //cell.mealImage.image = [UIImage imageNamed:@"mealSample.png"];  
        if (![ appDelegate checkInternetConnectivity]) {
            UserMealInfo *mealInfo = [[self.arrayDistMeals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
            if (!mealInfo.mealInfo.mealImage) // avoid the app icon download if the app already has an icon
            {
                NSString *imageName = [usermealInfo.mealInfo.image stringByReplacingOccurrencesOfString:@"http://" withString:@""];
                cell.mealImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageName]]; 
            }
            
        }

    }
    else
    {
        cell.mealImage.image = usermealInfo.mealInfo.mealImage;
    }

    
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

#pragma -
#pragma mark Rating delegate

-(void)changedRating:(int)rating {
	NSLog(@"Rating :%d",rating);
//    self.userMealInfo.mealRating = [NSString stringWithFormat:@"%d",rating];
}

#pragma -
#pragma mark Other methods

-(void)openMap:(id)sender{
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.mealTable indexPathForCell:clickedCell];

    MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
    mealMapController.userMealInfo = [[self.arrayDistMeals objectAtIndex:clickedButtonPath.section] objectAtIndex:clickedButtonPath.row];
    [self.navigationController pushViewController:mealMapController animated:TRUE];
    [mealMapController release];
}

#pragma -
#pragma mark search methods

- (IBAction)searchUsingContentsOfTextField:(id)sender {
    
    searchBarSelected = TRUE;    
    [self.filteredFriendMealArr removeAllObjects];
    NSString *searchString= ((UITextField *)sender).text;
    
    for (NSMutableArray *_arrayDistDate in self.arrayDistMeals) {
        
        NSMutableArray *_arrayMeals = [[NSMutableArray alloc] init];
        
        for (UserMealInfo *mealInfo in _arrayDistDate) {
            
            NSString *str = [NSString stringWithFormat:@"%@",mealInfo.mealInfo.meal_Name];
            if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound) {
                [_arrayMeals addObject:mealInfo];
            }
        }
        [self.filteredFriendMealArr addObject:_arrayMeals];
    }
    
    if ([((UITextField *)sender).text length]==0) {
        searchBarSelected = FALSE;
    }
    [self.mealTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    searchBarSelected = FALSE;
    return TRUE;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    searchBarSelected = FALSE;
    [self.mealTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];     
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
- (void)loadImagesForOnscreenRows {
    
            if ([self.arrayDistMeals count] > 0) {
            
            NSArray *visiblePaths = [self.mealTable indexPathsForVisibleRows];
            
            for (NSIndexPath *indexPath in visiblePaths) {
                UserMealInfo *mealInfo = [[self.arrayDistMeals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                
                if (!mealInfo.mealInfo.mealImage) // avoid the app icon download if the app already has an icon
                {
                    NSString *finalURL = mealInfo.mealInfo.image;
                    [self startIconDownloadWithLink:finalURL forIndexPath:indexPath];
                }
            }
        }
    
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath {
    
    if(imageDownloadsInProgress != nil) {
        IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
        if (iconDownloader != nil)
        {
            MealListCell *cell = (MealListCell*)[self.mealTable cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
            
            // Display the newly loaded image
            cell.mealImage.image = iconDownloader.iconImage;
            
            UserMealInfo *mealInfo = [[self.arrayDistMeals objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            mealInfo.mealInfo.mealImage = iconDownloader.iconImage;
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
