//
//  DigitalPlateAppDelegate.m
//  DigitalPlate
//
//  Created by iDroid on 12/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import "DigitalPlateAppDelegate.h"


@implementation DigitalPlateAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize tabbarController;
@synthesize indicatorView;
//@synthesize CurrentUserID;
@synthesize userInfo;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
    [self initializeDatabase];
    [self checkAndCreateDatabase];
    [self copyDBIfNotExist];
    database = [[DAL alloc] init];

    
    // Override point for customization after application launch.
    
    // Set the navigation controller as the window's root view controller and display.
//    LoginViewController *loginController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//	self.window.rootViewController = loginController;

	[self.window addSubview:navigationController.view];	
    [self.window makeKeyAndVisible];
	
	/*NSArray *arrayOnImages = [[NSArray alloc] initWithObjects:@"user_group.png",@"iconNumberOfFAVMeals@2x.png",@"list.png",nil];
	NSArray *arrayOfImages = [[NSArray alloc] initWithObjects:@"user_group.png",@"FullStarRatingMIDSize@2x.png",@"list.png",nil];	
	
	[tabbarController setImagesArray:arrayOnImages withOFFImages:arrayOfImages];
	[tabbarController addCenterButtonWithImage:[UIImage imageNamed:@"navMidCameraBtnNormal.png"] highlightImage:[UIImage imageNamed:@"navMidCameraBtnPresed.png"]]; */
    
    UIImage *selectedImage0 = [UIImage imageNamed:@"navLeftUsersBtnPresed.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"navLeftUsersBtnNormal.png"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"navMidCameraBtnPresed.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"navMidCameraBtnNormal.png"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@"navRightMenuBtnPresed.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"navRightMenuBtnNormal.png"];
    
    
    
    UITabBar *tabBar = tabbarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    

    
    self.indicatorView = [CustomActivityIndicatorView loadingViewWithMessageText:@"Loading..."];
    self.indicatorView.center = self.window.center;
    self.indicatorView.hidden=TRUE;
	[self.window addSubview: self.indicatorView];
    [self.window bringSubviewToFront:self.indicatorView];
//    self.CurrentUserID = [[[NSString alloc]init]autorelease];
//    self.CurrentUserID = @"2"; // Hard coded
    return YES;
}




#pragma mark - Database
- (void)initializeDatabase
{
    databaseName = @"DigitalPlate.sqlite";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
}
-(void) checkAndCreateDatabase{
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
}

- (void)copyDBIfNotExist 
{
    NSString *storedDB = [@"DigitalPlate.sqlite" pathInDocumentDirectory];
    NSLog (@" %@", storedDB);
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:storedDB])
        return;
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"DigitalPlate" ofType:@"sqlite"];
    
    NSError *copyingError;
    BOOL copyingSuccessfull = [manager copyItemAtPath:dbPath toPath:storedDB error:&copyingError];
    if (!copyingSuccessfull) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Database Error"
                                                        message:@"Application behavior will be unknown. Please restart the application." 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	[self.tabbarController onTabChange:tabBarController];
}

#pragma mark -
#pragma mark Activity Indicator

-(void)startActivityIndicator {
    self.indicatorView.hidden=FALSE;
    [self.window setUserInteractionEnabled:FALSE];
}

-(void)stopActivityIndicator {
    self.indicatorView.hidden=TRUE;        
    [self.window setUserInteractionEnabled:TRUE];    
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
    self.indicatorView = nil;
//    self.CurrentUserID = nil;
    self.userInfo = nil;
    
	[tabbarController release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (BOOL) checkInternetConnectivity {
    BOOL isNetworkAvailable = [DigitalPlateAppDelegate isNetworkAvailable];
    
    if(!isNetworkAvailable) {
//        UIAlertView *alertNetwork = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Network not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertNetwork show];
//        [alertNetwork release];
        
        [self stopActivityIndicator];
        return FALSE;
    }
    else {
          
        

        return TRUE;
    }
}

+ (BOOL)isNetworkAvailable  {
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];	
	return !(netStatus == NotReachable);
}

@end



#pragma mark -
#pragma mark Navigation bar customization

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed: @"topBarBG.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


