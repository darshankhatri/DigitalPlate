//
//  MealViewController.m
//  DigitalPlate
//
//  Created by iDroid on 17/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import "MealViewController.h"
#import "MealListController.h"
#import "UIImage+Resize.h"

@implementation MealViewController

#define ALERT_MEAL  1
#define ALERT_INFO  2

@synthesize detailView;
@synthesize recipeImage;
@synthesize recipePicker;
@synthesize ratingView;

@synthesize arrayRestaurant;

@synthesize mealUpdateButton;
@synthesize restaurantButton;
@synthesize locationButton;
@synthesize infoButton;

@synthesize txtMeal;
@synthesize lblMeal;

@synthesize lblRestaurant;
@synthesize lblLocation;
@synthesize lblInfo;
@synthesize txtMealInfo;
@synthesize btnFB;
@synthesize btnTW;
@synthesize objFacebook;
@synthesize objTwitter;
@synthesize userMealInfo;
@synthesize capturedImage;
@synthesize txtFieldFB;
@synthesize alrtFB;


#pragma mark -
#pragma mark Memory Management


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	[detailView release];
	[recipeImage release];
	[ratingView release];
    
    [arrayRestaurant release];
    
    [mealUpdateButton release];
    [restaurantButton release];
    [locationButton release];
    [infoButton release];
    
    [txtMeal release];
    [lblMeal release];    
    [lblRestaurant release];
    [lblLocation release];
    [lblInfo release];
    [txtMealInfo release];
    
    [userMealInfo release];
    [capturedImage release];
    [txtFieldFB release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

	self.navigationItem.title = @"Meal";

    //set right navigation item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(saveMeal:) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem];
	[rightItem release];
    
    //set left navigation item
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 55, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarButtonRightPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@" List" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(listButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftItem];
	[leftItem release];
    
    
    ratingView = [[RatingView alloc] initWithFrame:CGRectMake(198, 275, 87, 25)];
    [ratingView setBackgroundColor:[UIColor clearColor]];        
    [ratingView setDelegate:self];                
    [self.detailView addSubview:ratingView];
    [ratingView release];
	[self.detailView setHidden:TRUE];
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	self.recipePicker = imagePicker;
	[imagePicker release];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[self.recipePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.recipePicker setAllowsEditing:TRUE];
	}
	else {
		[self.recipePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.recipePicker setAllowsEditing:TRUE];        
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Your device does not support taking photos from camera. Redirecting you to Photos Library instead." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		//[alert show];
	}
	self.recipePicker.delegate = self;
    
    database = [[DAL alloc] init];
        
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.userMealInfo = nil;
    UserMealInfo *_usermealInfo = [[UserMealInfo alloc] init];
    self.userMealInfo = _usermealInfo;
    [_usermealInfo release];
    
    self.userMealInfo.mealInfo.mealRating = @"0";
    [self.lblInfo setText:@""];
    [self.lblMeal setText:@""];
    [self.lblLocation setText:@""];
    [self.lblRestaurant setText:@""];
    [self.ratingView setRating:[self.userMealInfo.mealInfo.mealRating intValue]];    
}

-(void)viewDidAppear:(BOOL)animated {
    if(!isModaledController) {
        isModaledController = !isModaledController;
        [self.tabBarController presentModalViewController:self.recipePicker animated:TRUE];	
    }    
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark -
#pragma mark TabledAlert Delegate

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context {
    //[[[UIAlertView alloc] initWithTitle:@"Selection Made" message:[NSString stringWithFormat:@"Index %d clicked", row] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
    if(row > -1){
        Restaurant *restaurant = [self.arrayRestaurant objectAtIndex:row];
        [self.lblRestaurant setText:restaurant.resturantName];
        [self.lblLocation setText:[NSString stringWithFormat:@"%@,%@",restaurant.latitude, restaurant.longitude]];
        self.userMealInfo.restaurant.restaurantID = restaurant.restaurantID;
    }
}


#pragma mark -
#pragma mark FaceBook Delegate

-(void)displayRequired {
	[self.view addSubview:self.objFacebook];
	[self.view bringSubviewToFront:self.objFacebook];
}

-(void)removeViewDialogue {
	[self.objFacebook setHidden:TRUE];
}

-(void)FBStatusMsg:(NSString *)status {
	
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate stopActivityIndicator];
    
	self.objFacebook._delegate=nil;
	UIAlertView *alrtStatus = [[UIAlertView alloc] 
                               initWithTitle:@"" 
                               message:status
                               delegate:nil 
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [alrtStatus show];
    [alrtStatus release];
}

#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:NO];
    isModaledController = !isModaledController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    UIImage *tempImage = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
    self.capturedImage = [tempImage imageByScalingToSize:CGSizeMake(tempImage.size.width/4, tempImage.size.height/4)];
	[self.detailView setHidden:FALSE];
	[self.recipeImage setImage:self.capturedImage];
    NSLog(@"Size :%@",NSStringFromCGSize(self.capturedImage.size));
    [[self.recipeImage layer]setCornerRadius:5.0];

	/*
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_email"];
	
    NSMutableString *imageName = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
	
    CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
    if (theUUID) {
        [imageName appendString:NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID))];
        CFRelease(theUUID);
    }
    [imageName appendString:@".png"];
	
    StatusBO *statusObj = [PhotoBO uploadImageFile:userName imageData:imageData file_name:imageName c_id:self.selected_category];
	
    if(statusObj.errorOccured == YES){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:statusObj.errorTitle message:statusObj.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else{
		//  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:statusObj.errorTitle message:statusObj.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alertView show];
        [self dismissModalViewControllerAnimated:NO];
    }
	*/
    
	[self dismissModalViewControllerAnimated:NO];
    isModaledController = !isModaledController;

    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![delegate checkInternetConnectivity])
    {
        NSMutableArray *returnArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
        [dt setObject:delegate.userInfo.UserID forKey:@"User_ID"];
        
        database = [[DAL alloc] init];
        NSString *query =[NSString stringWithFormat:@"SELECT * FROM restaurants"];
        NSDictionary *databaseValue = [database executeDataSet:query];
        
        NSArray *tempArray = [databaseValue allKeys];
        for (int i = 1; i <= [tempArray count]; i++) {
            
            NSString *databaseKey = [NSString stringWithFormat:@"Table %d",i];
            NSMutableDictionary *values =  [databaseValue objectForKey:databaseKey];
            NSMutableDictionary *Restaurant_OBJ = [[NSMutableDictionary alloc] init];
            [Restaurant_OBJ setValue:[values valueForKey:@"Address"] forKey:@"Address"];
            [Restaurant_OBJ setValue:[values valueForKey:@"City"] forKey:@"City"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Country"] forKey:@"Country"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Email"] forKey:@"Email"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Lat"] forKey:@"Lat"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Long"] forKey:@"Long"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Number_of_favourite_meal"] forKey:@"Number_of_favourite_meal"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Pincode"] forKey:@"Pincode"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Restaurant_ID"] forKey:@"Restaurant_ID"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Restaurant_Name"] forKey:@"Restaurant_Name"];
            [Restaurant_OBJ setValue:[values valueForKey:@"Website_Detail"] forKey:@"Website_Detail"];  
            
            Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:Restaurant_OBJ];
            [returnArray addObject:restaurant];
            NSLog(@"%d      %@", i , returnArray);
            
            
        }
        self.arrayRestaurant = returnArray;
        [self.arrayRestaurant  retain];
        NSLog(@"ArrayRestaurants:%@", self.arrayRestaurant);
        [returnArray release];
        return;
        
    }
    else {
        [delegate startActivityIndicator];
        self.arrayRestaurant = [RequestHandler getRestaurantList:nil];
        [delegate stopActivityIndicator];
    }
        

   
}



#pragma mark -
#pragma mark Rating View Delegate

-(void)changedRating:(int)rating {
	NSLog(@"Rating :%d",rating);
    self.userMealInfo.mealInfo.mealRating = [NSString stringWithFormat:@"%d",rating];
}

#pragma mark -
#pragma mark IB Outlet Actions

-(IBAction)updateMealName:(id)sender {
    
    if(!self.txtMeal) {

        CGRect frame = CGRectMake(14, 45, 255, 65);
        UITextView *textField = [[UITextView alloc] initWithFrame:frame];
        [textField.layer setCornerRadius:5.0];
        //textField.borderStyle = UITextBorderStyleBezel;
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = fontHelvetica14;
        //textField.placeholder = @"Meal Name";
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.keyboardType = UIKeyboardTypeEmailAddress; // use the default type input method (entire keyboard)
        textField.returnKeyType = UIReturnKeyDone;
        [textField becomeFirstResponder];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing; // has a clear 'x' button to the right    
        self.txtMeal = textField;
        [textField release];
        
        self.txtMeal.delegate = self;
    }
    
    [self.txtMeal setText:self.lblMeal.text];
    self.userMealInfo.mealInfo.meal_Name = self.txtMeal.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meal Name" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert addSubview:self.txtMeal];
    [alert setTag:ALERT_MEAL]; 
    [alert show];    
    [alert release];
}

-(IBAction)updateRestaurantName:(id)sender {
    RestaurantSelector *selector = [[RestaurantSelector alloc] initWithCaller:self data:self.arrayRestaurant title:@"Restaurants" andContext:nil];
    [selector show];
    [selector release];
}

-(IBAction)updateLocation:(id)sender {
    
}

-(IBAction)updateInfo:(id)sender {
    
    if(!self.txtMealInfo) {
        
        CGRect frame = CGRectMake(14, 45, 255, 65);
        UITextView *textField = [[UITextView alloc] initWithFrame:frame];
        [textField.layer setCornerRadius:5.0];
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = fontHelvetica14;
        textField.backgroundColor = [UIColor whiteColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textField.keyboardType = UIKeyboardTypeEmailAddress; // use the default type input method (entire keyboard)
        textField.returnKeyType = UIReturnKeyDone;
        [textField becomeFirstResponder];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing; // has a clear 'x' button to the right    
        self.txtMealInfo = textField;
        [textField release];
        
        self.txtMealInfo.delegate = self;
    }
    
    [self.txtMealInfo setText:self.lblInfo.text];
    self.userMealInfo.mealInfo.meal_Info = self.txtMealInfo.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Meal Info" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [alert addSubview:self.txtMealInfo];
    [alert setTag:ALERT_INFO]; 
    [alert show];    
    [alert release];   
}


-(IBAction)callFB:(id)sender {
    
    NSData *imageData = UIImageJPEGRepresentation(self.capturedImage, 0.7); 
    NSString *message = nil;

    if(!imageData) {
        message = @"Please select meal image";
        UIAlertView *alerMessage = [[UIAlertView alloc] initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerMessage show];
        [alerMessage release];
        return;
    }
    

    
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults]; 
	if([defaults valueForKey:@"fbData"] != nil)
	{
		if([[defaults valueForKey:@"fbData"] isEqualToString:@"0"] || [[defaults valueForKey:@"fbData"] isEqualToString:@""] || [[defaults valueForKey:@"fbData"] isEqualToString:@" "])
			self.alrtFB	= [[UIAlertView alloc] initWithTitle:@"Post on wall" message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
		else
			self.alrtFB	= [[UIAlertView alloc] initWithTitle:[defaults valueForKey:@"fbData"] message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
	}
	else {
		self.alrtFB	= [[UIAlertView alloc] initWithTitle:@"Post on wall" message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
	}
    
    txtFieldFB = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 65)];
    [txtFieldFB becomeFirstResponder];
    [txtFieldFB.layer setCornerRadius:5.0];  
    txtFieldFB.delegate=nil;
    [txtFieldFB setBackgroundColor:[UIColor whiteColor]];
    txtFieldFB.text=@"Meal 1";
    txtFieldFB.textAlignment=UITextAlignmentLeft;
    
    self.alrtFB	= [[UIAlertView alloc] initWithTitle:@"Post on wall" message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];


    [self.alrtFB addSubview:self.txtFieldFB];
    [self.alrtFB show];
    [self.alrtFB release];
   // [self.alrtFB release];
    

}


-(IBAction)callTW:(id)sender  {
    self.objTwitter = [[Twitter alloc] initWithFrame:CGRectMake(100,100,300,200) :@"Meal"];
	self.objTwitter.controllerDelegate = self;
	[self.view addSubview:self.objTwitter];
}



#pragma mark -
#pragma mark Server communication


-(void)saveMeal:(id)sender {
     
//    MealListController *mealListController = [[MealListController alloc] initWithNibName:@"MealListController" bundle:nil];
//    [self.navigationController pushViewController:mealListController animated:TRUE];
//    [mealListController release];
    

    
    NSLog(@"self.capturedImage :%@",self.capturedImage);
    NSData *imageData = UIImageJPEGRepresentation(self.capturedImage, 0.7); 
    NSString *message = nil;
    BOOL validated = TRUE;
    
    if(self.userMealInfo.mealInfo.meal_Name == nil || [self.userMealInfo.mealInfo.meal_Name isEqualToString:@""]) {
        message = @"Please update meal name.";
        validated = FALSE;
    }
    else if(self.userMealInfo.restaurant.restaurantID == nil || [self.userMealInfo.restaurant.restaurantID isEqualToString:@""]) {
        message = @"Please select a restaurant.";
        validated = FALSE;
    }
    else if(self.userMealInfo.mealInfo.meal_Info == nil || [self.userMealInfo.mealInfo.meal_Info isEqualToString:@""]) {
        message = @"Please enter meal info";
        validated = FALSE;
    }
    else if(!imageData) {
        message = @"Please select meal image";
        validated = FALSE;
    }
    else {
             
    }
    
    if(validated) {
        [NSThread detachNewThreadSelector:@selector(doSaveMeal) toTarget:self withObject:nil]; 
    }
    else {
        UIAlertView *alerMessage = [[UIAlertView alloc] initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerMessage show];
        [alerMessage release];
    }
    
}

- (void)doSaveMeal {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 
}

-(void)prepareRequestDirectory {
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
     NSString *strMessage;
    if(![appDelegate checkInternetConnectivity])
    {
       // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        database = [[DAL alloc] init];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int k = 0;
        if ([user valueForKey:@"imageValue"]) {
            k = [[user valueForKey:@"imageValue"]intValue];
        }

        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@%d.png",appDelegate.userInfo.UserID, k] ];
        
        NSData* data = UIImagePNGRepresentation(self.capturedImage);
        [data writeToFile:path atomically:YES];
        
        [path stringByAppendingFormat:@"%@%d.png",appDelegate.userInfo.UserID, k];
        k++;
        [user setValue:[NSString stringWithFormat:@"%d",k] forKey:@"imageValue"];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"dd.MM.yyyy"];
        [formatter2 setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        NSString *msg = [[NSString alloc] initWithFormat:@"%@", [formatter2 stringFromDate:[NSDate date]]];
        [formatter2 release];


        
        NSString *query = [NSString stringWithFormat:@"INSERT INTO mealDetails(Meal_Name,Restaurant_ID,Ratting, Info, Meal_ID, Address, Email, Lat, Long, Restaurant_Name, Website_Detail, Created, Is_Favorite, Number_of_favourite_meal, flag, Image, userId) VALUES('%@','%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '0', '%@','%@');",self.userMealInfo.mealInfo.meal_Name, self.userMealInfo.restaurant.restaurantID,self.userMealInfo.mealInfo.mealRating , self.userMealInfo.mealInfo.meal_Info, self.userMealInfo.mealInfo.meal_ID, self.userMealInfo.restaurant.address, self.userMealInfo.restaurant.email, self.userMealInfo.restaurant.latitude, self.userMealInfo.restaurant.longitude, self.userMealInfo.restaurant.resturantName, self.userMealInfo.restaurant.website, msg, self.userMealInfo.mealInfo.isFavorite, self.userMealInfo.restaurant.favoriteMeals, path, appDelegate.userInfo.UserID];
        [database execureScalar:query];
        strMessage = @"Meal saved Successfully ";

    }
    else {
        NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
        [dt setObject:appDelegate.userInfo.UserID  forKey:@"User_ID"];
        [dt setObject:self.userMealInfo.mealInfo.meal_Name forKey:@"Name"];
        [dt setObject:self.userMealInfo.restaurant.restaurantID forKey:@"Restaurant_ID"];
        [dt setObject:self.userMealInfo.mealInfo.mealRating forKey:@"Ratting"];
        [dt setObject:self.userMealInfo.mealInfo.meal_Info forKey:@"Info"];
        //[dt setObject:[NSString stringWithFormat:@"%@.jpg",userMealInfo.mealInfo.meal_Name] forKey:@"Image"];
        [dt setObject:@"0" forKey:@"Is_Favorite"];
        //[dt setObject:imageData forKey:@"userfile"];
        
        //Prepare Request
        NSMutableArray *message = [RequestHandler saveNewMeal:dt withImage:self.capturedImage];
        for(NSDictionary *dict in message) {
            strMessage = [dict valueForKey:@"Status"];
        }
    }

    // Prepare Meal Dictionary.
    NSLog(@"%@",strMessage);
    
    if([strMessage isEqualToString:MESSAGE_SAVE_MEAL]) {
        MealListController *mealListController = [[MealListController alloc] initWithNibName:@"MealListController" bundle:nil];
        mealListController.isFavMeal = FALSE;
        [self.navigationController pushViewController:mealListController animated:TRUE];
        [mealListController release];
    }
    
    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertError show];
    [alertError release];

    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate stopActivityIndicator];
    
}


-(void)listButtonPressed:(id)sender {    
//    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
//    [appDelegate.navigationController popToRootViewControllerAnimated:TRUE];
    
    MealListController *mealListController = [[MealListController alloc] initWithNibName:@"MealListController" bundle:nil];
    mealListController.isFavMeal = FALSE;
    [self.navigationController pushViewController:mealListController animated:TRUE];
    [mealListController release];

}

#pragma mark -
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView tag] == ALERT_MEAL && buttonIndex == 1) {
        [self.lblMeal setText:self.txtMeal.text];
        self.userMealInfo.mealInfo.meal_Name = self.txtMeal.text;
    }
    else if([alertView tag] == ALERT_INFO && buttonIndex == 1) {
        [self.lblInfo setText:self.txtMealInfo.text];
        self.userMealInfo.mealInfo.meal_Info = self.txtMealInfo.text;
    }
    else if(alertView == alrtFB && buttonIndex == 0)
    {
        DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
        [delegate startActivityIndicator];
        
        if(objFacebook)
            self.objFacebook = nil;
        
        objFacebook = [[faceBook alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        objFacebook.imageFB = UIImageJPEGRepresentation(self.capturedImage, 0.7); 
        objFacebook.strMsg=txtFieldFB.text;
        objFacebook._delegate=self;
        [objFacebook login];
       
    }
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
