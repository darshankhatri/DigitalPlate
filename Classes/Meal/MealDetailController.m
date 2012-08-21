//
//  MealDetailController.m
//  DigitalPlate
//
//  Created by iDroid on 23/03/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "MealDetailController.h"
#import "MealMapController.h"
#import "MealEditViewController.h"

@implementation MealDetailController

#define MEAL_HOLDER_VIEW    100
#define MEAL_IMAGE_VIEW     101
#define MEAL_SCROLL_VIEW    102

@synthesize lblMealName;
@synthesize btnRestaurant;
@synthesize btnMap;
@synthesize btnShare;
@synthesize imgMeal;
@synthesize ratingView;
@synthesize txtMealInfo;
@synthesize userMealInfo;
@synthesize mealEditController;
@synthesize restaurantController;
@synthesize alertViewSocialNet;
@synthesize txtFieldFB;
@synthesize alrtFB;
@synthesize objFacebook;
@synthesize objTwitter;



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
    [lblMealName release];
    [btnRestaurant release];
    [btnMap release];
    [btnShare release];
    [imgMeal release];
    [ratingView release];
    [txtMealInfo release];
    [mealEditController release];
    [restaurantController release];
    
    self.alertViewSocialNet=nil;
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

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
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(editMeal:) forControlEvents:UIControlEventTouchUpInside];
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
    
    ratingView = [[RatingView alloc] initWithFrame:CGRectMake(202, 13, 87, 25)];
    [ratingView setBackgroundColor:[UIColor clearColor]];        
    [ratingView setDelegate:self];       
    [ratingView setUserInteractionEnabled:FALSE];    
    [self.view addSubview:ratingView];
    [ratingView release];

    [self.lblMealName setText:self.userMealInfo.mealInfo.meal_Name];
    [self.ratingView setRating:[self.userMealInfo.mealInfo.mealRating intValue]];
    [self.txtMealInfo setText:self.userMealInfo.mealInfo.meal_Info];
        
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imgMeal.layer.masksToBounds = YES;
    self.imgMeal.layer.cornerRadius = 8.0;
    self.imgMeal.layer.borderWidth = 2.0;
    self.imgMeal.layer.borderColor = [[UIColor grayColor] CGColor];

}

-(void)viewDidAppear:(BOOL)animated {    
    if([self.userMealInfo.mealInfo.image length] > 0) {
        [self.imgMeal setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userMealInfo.mealInfo.image]]]];
    }
    self.imgMeal.layer.masksToBounds = YES;
    self.imgMeal.layer.cornerRadius = 8.0;
    self.imgMeal.layer.borderWidth = 2.0;
    self.imgMeal.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Bar button actions


-(void)backButtonPressed:(id)sender {    
    //    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)editMeal:(id)sender {    
    MealEditViewController *_mealEditController = [[MealEditViewController alloc] initWithNibName:@"MealEditViewController" bundle:nil];
    _mealEditController.userMealInfo = self.userMealInfo;
    self.mealEditController = _mealEditController;
    [self.navigationController pushViewController:self.mealEditController animated:TRUE];
    [mealEditController release];
}

#pragma mark -
#pragma mark Rating View Delegate

-(void)changedRating:(int)rating {
	NSLog(@"Rating :%d",rating);
    self.userMealInfo.mealInfo.mealRating = [NSString stringWithFormat:@"%d",rating];
}


#pragma mark -
#pragma mark Other Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *mealImageView = (UIImageView*)[self.view viewWithTag:MEAL_IMAGE_VIEW];
    return mealImageView;
}

-(void)closeImageDialog {
    UIView *mealHolderView = [self.view viewWithTag:MEAL_HOLDER_VIEW];
    if(mealHolderView != nil) {
        [mealHolderView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
    }
}

#pragma mark -
#pragma mark IB Outlet Actions

-(IBAction)zoomInMealImage:(id)sender {
    int xPos = 0;
    int yPos = 0;
    int totalWidth=self.view.frame.size.width;
    int totalHeight=self.view.frame.size.height;        
    
        
    UIView *mealHolderView=[[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, totalWidth, totalHeight)];
    [mealHolderView setTag:MEAL_HOLDER_VIEW];
    [mealHolderView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.95]];
        
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn.titleLabel setFont:fontHelveticaBold15];
    [closeBtn setFrame:CGRectMake((mealHolderView.frame.size.width/2)-(35),(mealHolderView.frame.size.height)-(35), 70, 30)];
    [closeBtn addTarget:self action:@selector(closeImageDialog) forControlEvents:UIControlEventTouchUpInside];
        
    UIScrollView *mealImageScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(xPos, yPos, totalWidth-(xPos*2), totalHeight-(yPos*2)-30)];        
    [mealImageScroll setTag:MEAL_SCROLL_VIEW];
    [mealImageScroll setBouncesZoom:YES];
    [mealImageScroll setMinimumZoomScale:0.80];
    [mealImageScroll setMaximumZoomScale:2.00];
    
    UIImage *mealImg=self.imgMeal.image;
    UIImageView *mealImgView=[[UIImageView alloc] initWithImage:mealImg];
    [mealImgView setTag:MEAL_IMAGE_VIEW];    
    [mealImgView setFrame:mealImageScroll.frame];
    [mealImgView setContentMode:UIViewContentModeCenter];
    [[mealImgView layer] setMasksToBounds:TRUE];
    [[mealImgView layer] setCornerRadius:8.0];
    [[mealImgView layer] setBorderWidth:2.0];
    [[mealImgView layer] setBorderColor:[[UIColor grayColor] CGColor]];
        
    [mealImgView setCenter:mealImageScroll.center];
    [mealImageScroll addSubview:mealImgView];
    [mealImageScroll setDelegate:self];
        
    [mealHolderView addSubview:mealImageScroll];
    [mealHolderView addSubview:closeBtn];
        
    [self.view addSubview:mealHolderView];        
    [mealImgView release];
    [mealImageScroll release];
    [mealHolderView release];
}


-(IBAction)viewRestaurantInfo:(id)sender {
    RestaurantViewController *_restaurantController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
    self.restaurantController = _restaurantController;
    self.restaurantController.userMealInfo = self.userMealInfo;
    [self.navigationController pushViewController:self.restaurantController animated:TRUE];
    [_restaurantController release];
}

-(IBAction)viewRestaurantLocation:(id)sender {
    MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
    mealMapController.userMealInfo = self.userMealInfo;
    [self.navigationController pushViewController:mealMapController animated:TRUE];
    [mealMapController release];
}

-(IBAction)shareTwitter:(id)sender {
    
    
    self.alertViewSocialNet = [[UIAlertView alloc] initWithTitle:@"Share" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"FaceBook",@"Twitter", nil];

    [self.alertViewSocialNet show];
    [self.alertViewSocialNet release];
    
}

#pragma mark -
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView == self.alertViewSocialNet && buttonIndex == 1) {
        [self callFB];
    }
    else if(alertView == self.alertViewSocialNet && buttonIndex == 2)
    {
        [self callTW];
    }
    else if(alertView == alrtFB && buttonIndex == 0)
    {
        DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
        [delegate startActivityIndicator];
        
        if(objFacebook)
            self.objFacebook = nil;
        
        objFacebook = [[faceBook alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        objFacebook.strMsg=txtFieldFB.text;
        objFacebook.imageFB = UIImageJPEGRepresentation(self.imgMeal.image, 0.7); 
        objFacebook._delegate=self;
        [objFacebook login];
        
    }
}

#pragma mark -
#pragma mark FaceBook Twitter Sharing

-(void)callTW  {
    self.alertViewSocialNet=nil;
    self.objTwitter = [[Twitter alloc] initWithFrame:CGRectMake(100,100,300,200) :self.userMealInfo.mealInfo.meal_Name];
	self.objTwitter.controllerDelegate = self;
	[self.view addSubview:self.objTwitter];
}

-(void)callFB {
    
    NSData *imageData = UIImageJPEGRepresentation(self.imgMeal.image, 0.7); 
    NSString *message = nil;
    
    if(!imageData) {
        message = @"No image to share";
        UIAlertView *alerMessage = [[UIAlertView alloc] initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerMessage show];
        [alerMessage release];
        return;
    }
    
    self.alertViewSocialNet=nil;
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
    txtFieldFB.text=self.userMealInfo.mealInfo.meal_Name;
    txtFieldFB.textAlignment=UITextAlignmentLeft;
    
    self.alrtFB	= [[UIAlertView alloc] initWithTitle:@"Post on wall" message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    
    
    [self.alrtFB addSubview:self.txtFieldFB];
    [self.alrtFB show];
    [self.alrtFB release];
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

-(void)displayRequired {

	[self.view addSubview:self.objFacebook];
	[self.view bringSubviewToFront:self.objFacebook];
}

-(void)removeViewDialogue {
    [self.objFacebook setHidden:TRUE];
}

#pragma mark -
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
