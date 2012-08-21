//
//  TabBarViewController.m
//  VTrak
//
//  Created by iDroid on 4/6/11.
//  Copyright 2012 iDroid. All rights reserved.
//

#import "TabBarViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ImageFrame CGRectMake(0, 10, 60, 26.0)
#define lableFrame CGRectMake(0, 34.0, 60, 12.0)

@implementation TabBarViewController

@synthesize lbl1;
@synthesize lbl2;
@synthesize lbl3;

@synthesize img1 = _img1;
@synthesize img2 = _img2;
@synthesize img3 = _img3;


@synthesize aryONImages = _aryONImages;
@synthesize aryOFFImages = _aryOFFImages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
    }
    return self;
}


- (void)dealloc
{
    self.img1 = nil;
	self.img2 = nil;
	self.img3 = nil;
	
	self.lbl1 = nil;
	self.lbl2 = nil;
	self.lbl3 = nil;
	
	self.aryONImages = nil;
	self.aryOFFImages = nil;
	
	self.delegate = nil;
	[super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	//NSLog(@"TabBarViewController :: didReceiveMemoryWarning");
	
	//Saving the Request data to log file	
}

#pragma mark -
#pragma mark Tabbar methods
// Code to set custom images for selected and non-selected states
- (void) setImagesArray:(NSArray *)aryONImages withOFFImages:(NSArray *)aryOFFImages 
{
	
	self.aryONImages = aryONImages;
	self.aryOFFImages = aryOFFImages;
	
//	UIView *tabView = (UIView *)[self.tabBar.subviews objectAtIndex:0];
	
//	float width = tabView.frame.size.width;
	CGRect imageRect = ImageFrame;
//	imageRect.size.width = width;
    
	
	CGRect labelRect = lableFrame;
//	labelRect.size.width = width;
    
    for (int i = 0; i < [self.tabBar.subviews count]; i++)  {
        UIView *view = [self.tabBar.subviews objectAtIndex:i];		
		if ([[view description] hasPrefix:@"<UITabBarButton:"]) 
		{
            imageRect.size.width = view.frame.size.width;
            labelRect.size.width = view.frame.size.width;
            break;
        }
    }
	
	UIImageView *_imgFirst = [[UIImageView alloc] init];
	_imgFirst.image=[UIImage imageNamed:[self.aryONImages objectAtIndex:0]];
	[_imgFirst setContentMode:UIViewContentModeCenter | UIViewContentModeScaleAspectFit];
	[_imgFirst setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[_imgFirst setFrame:imageRect];
	
	self.img1 = _imgFirst;
	[_imgFirst release];
	
	UILabel *lblTmp1 = [[UILabel alloc] initWithFrame:labelRect];
	lblTmp1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	lblTmp1.text = @"Summary";
	lblTmp1.textAlignment = UITextAlignmentCenter;
	lblTmp1.font = fontHelveticaBold09;
	lblTmp1.textColor = [UIColor whiteColor];
	lblTmp1.backgroundColor = [UIColor clearColor];
	self.lbl1 = lblTmp1;
	[lblTmp1 release];
	
	UIImageView *_imgSecond = [[UIImageView alloc] init];
	_imgSecond.image=[UIImage imageNamed:[self.aryOFFImages objectAtIndex:1]];	
	[_imgSecond setContentMode:UIViewContentModeCenter | UIViewContentModeScaleAspectFit];
	[_imgSecond setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[_imgSecond setFrame:imageRect];
	
	self.img2 = _imgSecond;
	[_imgSecond release];
	
	UILabel *lblTmp2 = [[UILabel alloc] initWithFrame:labelRect];
	lblTmp2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	lblTmp2.text = @"Device";
	lblTmp2.textAlignment = UITextAlignmentCenter;
	lblTmp2.font = fontHelveticaBold09;
	lblTmp2.textColor = [UIColor whiteColor];
	lblTmp2.backgroundColor = [UIColor clearColor];
	self.lbl2 = lblTmp2;
	[lblTmp2 release];
		
	UIImageView *_imgThird = [[UIImageView alloc] init];
	_imgThird.image=[UIImage imageNamed:[self.aryOFFImages objectAtIndex:2]];	
	[_imgThird setContentMode:UIViewContentModeCenter | UIViewContentModeScaleAspectFit];
	[_imgThird setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[_imgThird setFrame:imageRect];
	
	self.img3 = _imgThird;
	[_imgThird release];
	
	UILabel *lblTmp3 = [[UILabel alloc] initWithFrame:labelRect];
	lblTmp3.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	lblTmp3.text = @"Events";
	lblTmp3.textAlignment = UITextAlignmentCenter;
	lblTmp3.font = fontHelveticaBold09;
	lblTmp3.textColor = [UIColor whiteColor];
	lblTmp3.backgroundColor = [UIColor clearColor];
	self.lbl3 = lblTmp3;
	[lblTmp3 release];
	
	
//	self.tabBar.layer.contents = [UIImage imageNamed:@"tab-bar-iphone-potrait.png"];
	
	/*
	CGRect frame = CGRectMake(0.0, 0, self.view.bounds.size.width, 48);	
	UIImageView *v = [[UIImageView alloc] initWithFrame:frame];
	//[v setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBackground.png"]]];
	[v setImage:[UIImage imageNamed:@"tabBG.png"]];	
	[self.view insertSubview:v atIndex:0];
	[v release];
	*/
	
	CGImageRef newTabBarImageRef = [[UIImage imageNamed:@"tabBG.png"] CGImage];
	//self.tabBar.layer.contents = [UIImage imageNamed:@"tabBG.png"];
    self.tabBar.layer.contents = (id)newTabBarImageRef;
	

	
	for (int i = 0; i < [self.tabBar.subviews count]; i++)  {
		
		UIView *view = [self.tabBar.subviews objectAtIndex:i];		
		if ([[view description] hasPrefix:@"<UITabBarButton:"]) 
		{
			NSUInteger index = (view.frame.origin.x > view.frame.size.width)?(view.frame.origin.x - 6.0)/view.frame.size.width:0;
			if(index == 0) 
			{
				[view addSubview:_img1];
				//[view addSubview:self.lbl1];
                UIImageView *imgViewLeftBite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftBite.png"]];
                [imgViewLeftBite setFrame:CGRectMake(0,0,20,20)];
                [view addSubview:imgViewLeftBite];
                [imgViewLeftBite release];
			}
			else if (index == 1)
			{
				[view addSubview:_img2];
				//[view addSubview:self.lbl2];
			}
			else if (index == 2)
			{
				[view addSubview:_img3];
				//[view addSubview:self.lbl3];
                UIImageView *imgViewLeftBite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightBite.png"]];
                [imgViewLeftBite setFrame:CGRectMake(85,0,20,20)];
                [view addSubview:imgViewLeftBite];
                [imgViewLeftBite release];
			}
		}
	}
	
}

-(void)selctSecond {
	[self setSelectedIndex:1];
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(selctSecond) forControlEvents:UIControlEventTouchUpInside];

	
	CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
	if (heightDifference < 0)
		button.center = self.tabBar.center;
	else
	{
		button.center = CGPointMake(self.tabBar.center.x, self.tabBar.center.y - (button.frame.size.height - self.tabBar.frame.size.height - 5));
	}
	
	[self.view addSubview:button];
		
}


- (void) onTabChange:(UITabBarController *)tabBarController  {	
	int j = tabBarController.selectedIndex;
	
	for (int i = 0; i < [self.tabBar.subviews count]; i++) {
        UIView *view = [self.tabBar.subviews objectAtIndex:i];		
        if ([[view description] hasPrefix:@"<UITabBarButton:"]) 
        {
            NSUInteger index = (view.frame.origin.x > view.frame.size.width)?(view.frame.origin.x - 6.0)/view.frame.size.width:0;
			if(index == 0) 
			{
				if(j==index) 
				{
					[_img1 setImage:[UIImage imageNamed:[_aryONImages objectAtIndex:0]]]; 
					lbl1.textColor = [UIColor whiteColor];
				}
				else 
				{		
					[_img1 setImage:[UIImage imageNamed:[_aryOFFImages objectAtIndex:0]]];
					lbl1.textColor = [UIColor whiteColor];
				}
			}
			else if (index == 1)
			{
				if(j==index)
				{	
					[_img2 setImage:[UIImage imageNamed:[_aryONImages objectAtIndex:1]]];
					lbl2.textColor = [UIColor whiteColor];
				}
				else
				{		
					[_img2 setImage:[UIImage imageNamed:[_aryOFFImages objectAtIndex:1]]];
					lbl2.textColor = [UIColor whiteColor];
					
				}
			}	
			else if (index==2)
			{
				if(j==index)
				{	
					[_img3 setImage:[UIImage imageNamed:[_aryONImages objectAtIndex:2]]];
					lbl3.textColor = [UIColor whiteColor];
				}
				else
				{	
					[_img3 setImage:[UIImage imageNamed:[_aryOFFImages objectAtIndex:2]]];
					lbl3.textColor = [UIColor whiteColor];
				}
			}
		}		
	}
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	if (viewController == tabBarController.selectedViewController) {
		return NO;
	} else {
		return YES;
	}
}


//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//	[self onTabChange:tabBarController];
//}

@end
