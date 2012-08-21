//
//  FriendMealInfoViewController.m
//  DigitalPlate
//
//  Created by iDeveloper on 3/15/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FriendMealInfoViewController.h"
#import "FullScreenView.h"
#import "MealMapController.h"
#import "RestaurantViewController.h"

@implementation FriendMealInfoViewController

#define MEAL_HOLDER_VIEW    100
#define MEAL_IMAGE_VIEW     101
#define MEAL_SCROLL_VIEW    102

@synthesize meal;
@synthesize ratingView;
@synthesize mealImage;
@synthesize moreButton;
@synthesize descriptionTextView;
@synthesize mealName;

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
    self.ratingView = nil;
    [mealImage release];
    [moreButton release];
    [descriptionTextView release];
    [mealName release];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Meal";
  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBackground.png"] forBarMetrics: UIBarMetricsDefault];
    } 

    
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
        
    self.ratingView = [[[RatingView alloc]initWithFrame:CGRectMake(43, 160, 100, 15)] autorelease];
    self.ratingView.backgroundColor = [UIColor clearColor];
    self.ratingView.userInteractionEnabled = FALSE;
    [self.ratingView setRating:[meal.mealInfo.mealRating intValue]];
    [self.view addSubview:self.ratingView];
    mealName.text = meal.mealInfo.meal_Name;
    descriptionTextView.text = meal.mealInfo.meal_Info;
    
    self.mealImage.layer.masksToBounds = YES;
    self.mealImage.layer.cornerRadius = 8.0;
    self.mealImage.layer.borderWidth = 2.0;
    self.mealImage.layer.borderColor = [[UIColor grayColor] CGColor];

}

-(void)viewDidAppear:(BOOL)animated {
    if([self.meal.mealInfo.image length] > 0) {
        [self.mealImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.meal.mealInfo.image]]]];
    }
    
    self.mealImage.layer.masksToBounds = YES;
    self.mealImage.layer.cornerRadius = 8.0;
    self.mealImage.layer.borderWidth = 2.0;
    self.mealImage.layer.borderColor = [[UIColor grayColor] CGColor];

    [super viewDidAppear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Bar Button Actions

-(void)backButtonPressed:(id)sender {    
    //DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

-(void)addClicked {
    DigitalPlateAppDelegate *appDelegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(![appDelegate checkInternetConnectivity])
        return;

    
    NSMutableDictionary *dt1 = [[NSMutableDictionary alloc]init];
    [dt1 setObject:self.meal.mealInfo.meal_ID forKey:@"Meal_ID"];   
    [dt1 setObject:appDelegate.userInfo.UserID forKey:@"User_ID"];       
    NSArray *arr =[RequestHandler addMealToFav:dt1];
    NSString *str = [[arr objectAtIndex:0] valueForKey:@"Status"];
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Digital Plate" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark IB Outlet Actions

-(IBAction)goToRestaurantClicked:(id)sender
{
    RestaurantViewController *_restaurantController = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:nil];
    
    _restaurantController.userMealInfo = self.meal;
    [self.navigationController pushViewController:_restaurantController animated:TRUE];
    [_restaurantController release];

}
-(IBAction)gotoLocationClicked:(id)sender
{
    MealMapController *mealMapController = [[MealMapController alloc] initWithNibName:@"MealMapController" bundle:nil];
    mealMapController.userMealInfo = self.meal;
    [self.navigationController pushViewController:mealMapController animated:TRUE];
    [mealMapController release];
}

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
    
    UIImage *mealImg=self.mealImage.image;
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


-(IBAction)moreButtonClicked:(id)sender {
    
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
#pragma mark Orientation Support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
