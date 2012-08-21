//
//  FriendAndRequestListViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FriendAndRequestListViewController.h"
#import "FriendRequestCell.h"
#import "LatestMealCell.h"
#import "FriendsFullProfileViewController.h"
#import "RequestHandler.h"
#import "FriendRequest.h"


@implementation FriendAndRequestListViewController
@synthesize friendsArray;
@synthesize requestArray;
@synthesize filteredFriendsArr;
@synthesize filteredRequestArr;

@synthesize searchTextField;
@synthesize friendsTable;


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

-(void)dealloc {
    self.friendsTable.dataSource = nil;
    self.friendsTable.delegate = nil;
    
    self.filteredFriendsArr=nil;
    self.filteredRequestArr=nil;
    self.friendsArray=nil;
    self.requestArray = nil;
    
    [searchTextField release];    
    [friendsTable release];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBackground.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    self.title = @"Friends";
    
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
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 55, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Add+" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    //[button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem];
	[rightItem release];
   
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated  {
    [self.searchTextField setText:@""];
    searchBarSelected = FALSE;
    
    self.filteredFriendsArr = [NSMutableArray array];
    self.filteredRequestArr = [NSMutableArray array];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    if([self.searchTextField isFirstResponder])
        [self.searchTextField resignFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Bar Button Actions

-(void)backButtonPressed:(id)sender {    
    
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark Server Communication

-(void)prepareRequestDirectory {
    
    DigitalPlateAppDelegate *appDel = [[UIApplication sharedApplication]delegate];
    if(![appDel checkInternetConnectivity])
        return;

    NSMutableDictionary *_dictionary = [[NSMutableDictionary alloc] init];
    //    [dt1 setObject:@"2" forKey:@"User_ID"];
    [_dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];
    self.requestArray = [RequestHandler getFriendRequestList:_dictionary];
    
    if([self.requestArray count]==1 && [[self.requestArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        [self.requestArray removeAllObjects];
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dt setObject:@"2" forKey:@"User_ID"];
    [dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];
    
    self.friendsArray = [RequestHandler getFriendsList:dictionary];
    
    if([self.friendsArray count] > 0 && [[self.friendsArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MESSAGE_NO_FRIEND_FOUND delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [self.friendsArray removeAllObjects];
    }
    

    [dictionary release];
    [_dictionary release];

    
    [friendsTable reloadData];
    [appDel stopActivityIndicator];
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowheight;
    if (indexPath.section==0)
    {
        rowheight = 60;
    }
    else
    {
        rowheight = 60;
    }
	
	return rowheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    int rowheight;
    
    if(searchBarSelected) {
        
        if (section==0) {
            
            if([self.filteredRequestArr count] > 0)
                rowheight = 27;
            else 
                rowheight = 0;
        }
        
        else {
            if([self.filteredFriendsArr count] > 0 )
                rowheight = 27;
            else 
                rowheight = 0;
        }
    }
    else {
        if (section==0) {
            
            if([self.requestArray count] > 0)
                rowheight = 27;
            else 
                rowheight = 0;
        }
        
        else {
            if([self.friendsArray count] > 0 )
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

    
    switch (section) 
	{
		case 0:
			label.text= @"Requests";
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int row;
    if (section==0)
    {
        if (searchBarSelected)
        {
            row = [self.filteredRequestArr count];
        }
        else
        {
            row = [self.requestArray count];
        }
    }
    else
    {
        if (searchBarSelected)
        {
            row = [self.filteredFriendsArr count];
        }
        else
        {
            row = [self.friendsArray count];
        }
            
    }
    return row;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *CellIdentifier = @"FriendRequestCell";
        static NSString *CellNib = @"FriendRequestCell";
        
		FriendRequestCell *cell = (FriendRequestCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
		if (cell == nil)  {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
			cell = (FriendRequestCell *)[nib objectAtIndex:0];
            [cell.deleteButton addTarget:self action:@selector(deleteRequestClicked:) forControlEvents:UIControlEventTouchUpInside];        
            [cell.addButton addTarget:self action:@selector(addRequestClicked:) forControlEvents:UIControlEventTouchUpInside];                    
		}
		        
		// perform additional custom work...
        FriendRequest *request;
        if (searchBarSelected) {
            request = [self.filteredRequestArr objectAtIndex:indexPath.row];
        }
        else {
            request = [self.requestArray objectAtIndex:indexPath.row];
        }        
        
//        cell.deleteButton.tag = indexPath.row;
//        [cell.deleteButton addTarget:self action:@selector(deleteRequestClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        cell.addButton.tag = indexPath.row;
//        [cell.addButton addTarget:self action:@selector(addRequestClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //cell.friendImage = nil;
        cell.friendImage.image = [UIImage imageNamed:@"User.png"];
        cell.friendImage.layer.masksToBounds = YES;
        cell.friendImage.layer.cornerRadius = 7.0;
        cell.friendImage.layer.borderWidth = 1.0;
        cell.friendImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
        cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@",request.userInfo.firstName,request.userInfo.lastName];
        
        cell.numOfFavMeal.text = request.numberOfFavorites;
        cell.numOfFriendRequest.text = request.numberOfFriends;
        cell.numOfRestaurant.text = request.numberOfRestaurant;
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
		
         
		return cell;
        
    }
    else
    {
        static NSString *CellIdentifier = @"LatestMealCell";
        static NSString *CellNib = @"LatestMealCell";
        
		LatestMealCell *cell = (LatestMealCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) 
		{
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
			cell = (LatestMealCell *)[nib objectAtIndex:0];
		}
		
		// perform additional custom work...
        Friends *friend;
        
        if (searchBarSelected) {
            friend = [self.filteredFriendsArr objectAtIndex:indexPath.row];
        }
        else {
            friend = [self.friendsArray objectAtIndex:indexPath.row];
        }
        
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        
        if (friend.firstName!=NULL && friend.lastName != NULL) {
                cell.friendNameLabel.text = [NSString stringWithFormat:@"%@ %@",friend.firstName,friend.lastName];
        }
		else if(friend.firstName!=NULL) {
            cell.friendNameLabel.text =[NSString stringWithFormat:@"%@",friend.firstName];
        }
        cell.mealNameLabel.text = friend.lastName;
        
        if (friend.numOfFriends != NULL) {
             cell.numOfFriendRequest.text = friend.numOfFriends;
        }
       
        if (friend.numOfFavMeals!=NULL) {
            cell.numOfFavMeal.text = friend.numOfFavMeals;
        }
        
        if (friend.numberOfRestaurant!=NULL) {
            cell.numberOfRestaurant.text = friend.numberOfRestaurant;
        }
        
        cell.mealNameLabel.text = friend.lastMeal;
        
        cell.friendImage.image = [UIImage imageNamed:@"User.png"];
        cell.friendImage.layer.masksToBounds = YES;
        cell.friendImage.layer.cornerRadius = 7.0;
        cell.friendImage.layer.borderWidth = 1.0;
        cell.friendImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
		return cell;
        
    }
}


#pragma mark -
#pragma mark Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1)
    {
        FriendsFullProfileViewController *controller = [[FriendsFullProfileViewController alloc]initWithNibName:@"FriendsFullProfileViewController" bundle:nil];
        if (searchBarSelected)
        {
            controller.friendProfile =[self.filteredFriendsArr objectAtIndex:indexPath.row];
        }
        else
        {
            controller.friendProfile =[self.friendsArray objectAtIndex:indexPath.row];
        }
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark -
#pragma mark Freind Request Handling

-(void)deleteRequestClicked:(id)sender {
    DigitalPlateAppDelegate *appDel = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDel startActivityIndicator];
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.friendsTable indexPathForCell:clickedCell];

    
//    UIButton *btn = (UIButton*)sender;
//    int index = btn.tag;
    deleteIndex = clickedButtonPath.row;
    [NSThread detachNewThreadSelector:@selector(doDelete) toTarget:self withObject:nil]; 
    
}

-(void)doDelete {
    DigitalPlateAppDelegate *appDel = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];    
    if(![appDel checkInternetConnectivity])
        return;

    Friends *friend = [self.friendsArray objectAtIndex:deleteIndex];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];
    [dictionary setObject:friend.UserID forKey:@"Friend_ID"];
    [dictionary setObject:@"0" forKey:@"Status"];
    
    NSArray *responseArray = [RequestHandler confirmFriend:dictionary];
    if([responseArray count] > 0 && [[[responseArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[responseArray objectAtIndex:0] valueForKey:@"Status"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil];         
    }
    else {
        [appDel stopActivityIndicator];
    }
}

-(void)addRequestClicked:(id)sender
{
    DigitalPlateAppDelegate *appDel = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDel startActivityIndicator];
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *clickedButtonPath = [self.friendsTable indexPathForCell:clickedCell];
    
    
    //    UIButton *btn = (UIButton*)sender;
    //    int index = btn.tag;
    deleteIndex = clickedButtonPath.row;
    [NSThread detachNewThreadSelector:@selector(doAdd) toTarget:self withObject:nil]; 
}

-(void)doAdd {
    DigitalPlateAppDelegate *appDel = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];    
    if(![appDel checkInternetConnectivity])
        return;

    Friends *friend = [self.friendsArray objectAtIndex:deleteIndex];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:appDel.userInfo.UserID forKey:@"User_ID"];
    [dictionary setObject:friend.UserID forKey:@"Friend_ID"];
    [dictionary setObject:@"1" forKey:@"Status"];
    
    NSArray *responseArray = [RequestHandler confirmFriend:dictionary];
    if([responseArray count] > 0 && [[[responseArray objectAtIndex:0] allKeys] containsObject:@"Status"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[responseArray objectAtIndex:0] valueForKey:@"Status"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil];         
    }
    else {
        [appDel stopActivityIndicator];
    }
}

#pragma mark -
#pragma mark search methods

- (IBAction)searchUsingContentsOfTextField:(id)sender {
    
    searchBarSelected = TRUE;    
    [self.filteredRequestArr removeAllObjects];
    [self.filteredFriendsArr removeAllObjects];
    NSString *searchString= ((UITextField *)sender).text;
    
    for (Friends *friend in self.friendsArray)
	{
        NSString *str = [NSString stringWithFormat:@"%@ %@",friend.firstName,friend.lastName];
		if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location != NSNotFound)
        {
            [self.filteredFriendsArr addObject:friend];
        }
        
	}
    
    for (FriendRequest *friendRequest in self.requestArray)
	{
        NSString *str = [NSString stringWithFormat:@"%@ %@",friendRequest.userInfo.firstName,friendRequest.userInfo.lastName];
		if ([[str lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound)
        {
            [self.filteredRequestArr addObject:friendRequest];
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
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
