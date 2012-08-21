//
//  MealEditViewController.m
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MealEditViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"


@implementation MealEditViewController

#define ALERT_MEAL  1
#define ALERT_INFO  2

@synthesize btnCamera;
@synthesize btnRemoveMeal;
@synthesize btnMealName;
@synthesize btnRestaurantName;
@synthesize btnMealInfo;

@synthesize lblMeal;
@synthesize lblRestaurant;
@synthesize lblLocation;
@synthesize lblInfo;

@synthesize ratingView;
@synthesize userMealInfo;

@synthesize recipePicker;
@synthesize capturedImage;
@synthesize recipeImage;
@synthesize arrayRestaurant;

@synthesize txtMeal;
@synthesize txtMealInfo;

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
    [btnCamera release];
    [btnRemoveMeal release];
    [btnMealName release];
    [btnRestaurantName release];
    [btnMealInfo release];
    [ratingView release];
    
    [lblMeal release];
    [lblRestaurant release];
    [lblLocation release];
    [lblInfo release];
    
    [recipePicker release];
    [capturedImage release];
    [recipeImage release];
    
    [arrayRestaurant release];
    
    [txtMeal release];
    [txtMealInfo release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarBG.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    self.navigationItem.title = @"Edit meal info";

    
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
    [button setBackgroundImage:[UIImage imageNamed:@"topBarBtnBackNormal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"topBarBtnBackPresed.png"] forState:UIControlStateSelected];
    [button setTitle:@" Back" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];    
    [button.titleLabel setFont:fontHelveticaBold12];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:leftItem];
	[leftItem release];
    
    ratingView = [[RatingView alloc] initWithFrame:CGRectMake(213, 268, 87, 25)];
    [ratingView setBackgroundColor:[UIColor clearColor]];        
    [ratingView setDelegate:self];                
    [self.view addSubview:ratingView];
    [ratingView release];

    [self.lblInfo setText:self.userMealInfo.mealInfo.meal_Info];
    [self.lblMeal setText:self.userMealInfo.mealInfo.meal_Name];
    [self.lblRestaurant setText:self.userMealInfo.restaurant.resturantName];
    [self.lblLocation setText:[NSString stringWithFormat:@"%@,%@",self.userMealInfo.restaurant.latitude, self.userMealInfo.restaurant.longitude]];
    [self.ratingView setRating:[self.userMealInfo.mealInfo.mealRating intValue]];
    [[self.recipeImage layer]setCornerRadius:8.0];
    
    [super viewDidLoad];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	self.recipePicker = imagePicker;
	[imagePicker release];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[self.recipePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
	}
	else {
		[self.recipePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	self.recipePicker.delegate = self;

    // Do any additional setup after loading the view from its nib.
    
    self.recipeImage.layer.masksToBounds = YES;
    self.recipeImage.layer.cornerRadius = 8.0;
    self.recipeImage.layer.borderWidth = 2.0;
    self.recipeImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    if([self.userMealInfo.mealInfo.image length] > 0) {
        [self.recipeImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userMealInfo.mealInfo.image]]]];
    }
    
    self.recipeImage.layer.masksToBounds = YES;
    self.recipeImage.layer.cornerRadius = 8.0;
    self.recipeImage.layer.borderWidth = 2.0;
    self.recipeImage.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [NSThread detachNewThreadSelector:@selector(doGetRestaurant) toTarget:self withObject:nil]; 
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Server communication


-(void)doGetRestaurant {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(getRestaurant) toTarget:self withObject:nil]; 
}

-(void)getRestaurant {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![delegate checkInternetConnectivity])
        return;

//    [delegate startActivityIndicator];
    self.arrayRestaurant = [RequestHandler getRestaurantList:nil];
    [delegate stopActivityIndicator];
}

- (void)doSaveMeal {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRequestDirectory) toTarget:self withObject:nil]; 
}

-(void)prepareRequestDirectory {
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(![appDelegate checkInternetConnectivity])
    {
        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        database = [[DAL alloc] init];
//        NSString* path = [documentsDirectory stringByAppendingPathComponent: 
//                          [NSString stringWithFormat: @"%@%d.png",appDelegate.userInfo.UserID,i] ];
//        NSData* data = UIImagePNGRepresentation(myImage);
//        [data writeToFile:path atomically:YES];
//        
//        [path stringByAppendingFormat:@"%@%d.png",appDelegate.userInfo.UserID,i];
//        
//        NSString *query = [NSString stringWithFormat:@"INSERT INTO mealDetails(Meal_Name,Restaurant_ID,Ratting, Info, Meal_ID, Address, Email, Lat, Long, Restaurant_Name, Website_Detail, Created, Is_Favorite, Number_of_favourite_meal, flag) VALUES('%@','%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '1');",userMealInfo.mealInfo.meal_Name, userMealInfo.restaurant.restaurantID,userMealInfo.mealInfo.mealRating , userMealInfo.mealInfo.meal_Info, userMealInfo.mealInfo.meal_ID, userMealInfo.restaurant.address, userMealInfo.restaurant.email, userMealInfo.restaurant.latitude, userMealInfo.restaurant.longitude, userMealInfo.restaurant.resturantName, userMealInfo.restaurant.website, userMealInfo.mealInfo.created, userMealInfo.mealInfo.isFavorite, userMealInfo.restaurant.favoriteMeals];
//        [database execureScalar:query];

        return;
    }
    else {
        NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
        [dt setObject:appDelegate.userInfo.UserID  forKey:@"User_ID"];
        [dt setObject:self.userMealInfo.mealInfo.meal_ID  forKey:@"Meal_ID"];
        [dt setObject:self.userMealInfo.mealInfo.meal_Name forKey:@"Name"];
        [dt setObject:self.userMealInfo.restaurant.restaurantID forKey:@"Restaurant_ID"];
        [dt setObject:self.userMealInfo.mealInfo.mealRating forKey:@"Ratting"];
        [dt setObject:self.userMealInfo.mealInfo.meal_Info forKey:@"Info"];
        //[dt setObject:[NSString stringWithFormat:@"%@.jpg",userMealInfo.mealInfo.meal_Name] forKey:@"Image"];
        [dt setObject:@"0" forKey:@"Is_Favorite"];
        //[dt setObject:imageData forKey:@"userfile"];
        
        //Prepare Request
        NSMutableArray *message = [RequestHandler saveNewMeal:dt withImage:self.capturedImage]; 
        NSString *strMessage;
        for(NSDictionary *dict in message) {
            strMessage = [dict valueForKey:@"Status"];
        }
        
        NSLog(@"%@",strMessage);
        
        if([strMessage isEqualToString:MESSAGE_SAVE_MEAL]) {
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertError show];
            [alertError release];
        }
        
        DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
        [delegate stopActivityIndicator];

    }

    // Prepare Meal Dictionary.
       
}

- (void)doRemoveMeal {
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate startActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(prepareRemoveDirectory) toTarget:self withObject:nil]; 
}

-(void)prepareRemoveDirectory {
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(![appDelegate checkInternetConnectivity])
        return;
    
    
    // Prepare Meal Dictionary.
    NSMutableDictionary *dt = [[NSMutableDictionary alloc] init];
    [dt setObject:appDelegate.userInfo.UserID  forKey:@"User_ID"];
    [dt setObject:self.userMealInfo.mealInfo.meal_ID forKey:@"Meal_ID"];
    
    //Prepare Request
    NSMutableArray *message = [RequestHandler removeMeal:dt]; 
    NSString *strMessage;
    for(NSDictionary *dict in message) {
        strMessage = [dict valueForKey:@"Status"];
    }
    
    NSLog(@"%@",strMessage);
    
    if([strMessage isEqualToString:MESSAGE_MEAL_DELETED]) {
        //[self.navigationController popToRootViewControllerAnimated:TRUE];
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:TRUE];
    }
    
    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertError show];
    [alertError release];
    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate stopActivityIndicator];
    
}


#pragma mark -
#pragma mark Bar Button actions

-(void)saveMeal:(id)sender {
    NSLog(@"self.capturedImage :%@",self.capturedImage);
    NSData *imageData = UIImageJPEGRepresentation(self.capturedImage, 0.9); 
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


-(void)backButtonPressed:(id)sender {    
    //DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark -
#pragma mark UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:NO];
//    isModaledController = !isModaledController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
//    self.capturedImage = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
//	[self.recipeImage setImage:self.capturedImage];
    
    UIImage *tempImage = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
    self.capturedImage = [tempImage imageByScalingToSize:CGSizeMake(tempImage.size.width/4, tempImage.size.height/4)];
	[self.recipeImage setImage:self.capturedImage];
    //[[self.recipeImage layer]setCornerRadius:5.0];

    
	[self dismissModalViewControllerAnimated:NO];
    //isModaledController = !isModaledController;
    
    DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![delegate checkInternetConnectivity])
        return;

    [delegate startActivityIndicator];
    self.arrayRestaurant = [RequestHandler getRestaurantList:nil];
    [delegate stopActivityIndicator];
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

-(IBAction)updateImage:(id)sender {
    [self.tabBarController presentModalViewController:self.recipePicker animated:TRUE];	   
}

-(IBAction)removeRestaurant:(id)sender {
    [NSThread detachNewThreadSelector:@selector(doRemoveMeal) toTarget:self withObject:nil]; 
}


#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView tag] == ALERT_MEAL && buttonIndex == 1) {
        [self.lblMeal setText:self.txtMeal.text];
        self.userMealInfo.mealInfo.meal_Name = self.txtMeal.text;
    }
    else if([alertView tag] == ALERT_INFO && buttonIndex == 1) {
        [self.lblInfo setText:self.txtMealInfo.text];
        self.userMealInfo.mealInfo.meal_Info = self.txtMealInfo.text;
    }
}


#pragma mark -
#pragma mark TabledAlert Delegate

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context {
    //[[[UIAlertView alloc] initWithTitle:@"Selection Made" message:[NSString stringWithFormat:@"Index %d clicked", row] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
    if(row > -1){
        [self.lblRestaurant setText:self.userMealInfo.restaurant.resturantName];
        [self.lblLocation setText:[NSString stringWithFormat:@"%@,%@",self.userMealInfo.restaurant.latitude, self.userMealInfo.restaurant.longitude]];
        self.userMealInfo.restaurant.restaurantID = self.userMealInfo.restaurant.restaurantID;
    }
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
