//
//  TabBarViewController.h
//  VTrak
//
//  Created by iDroid on 4/6/11.
//  Copyright 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController<UITabBarControllerDelegate> {

	//	Tab bar images
	UIImageView *_img1;
	UILabel *lbl1;
	
	UIImageView *_img2;
	UILabel *lbl2;
	
	UIImageView *_img3;
	UILabel *lbl3;
	
	int selind;
	//	Image swapping
	NSArray *_aryONImages;
	NSArray *_aryOFFImages;
	
@private
	NSUInteger eventBadgeValue;
}

@property (nonatomic, retain) UILabel *lbl1;
@property (nonatomic, retain) UILabel *lbl2;
@property (nonatomic, retain) UILabel *lbl3;

@property (nonatomic, retain) UIImageView *img1;
@property (nonatomic, retain) UIImageView *img2;
@property (nonatomic, retain) UIImageView *img3;

@property (nonatomic, retain) NSArray *aryONImages;
@property (nonatomic, retain) NSArray *aryOFFImages;

- (void) setImagesArray:(NSArray *)aryONImages withOFFImages:(NSArray *)aryOFFImages;
- (void) onTabChange:(UITabBarController *)tabBarController;
- (void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;
- (void) onTabChange:(UITabBarController *)tabBarController;


@end
