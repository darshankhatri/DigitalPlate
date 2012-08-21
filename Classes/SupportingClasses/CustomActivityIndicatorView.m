//
//  CustomActivityIndicatorView.m
//  CustomActivityIndicator
//
//  Created by RupakParikh on 09/12/10.
//  Copyright 2010 iDroid. All rights reserved.
//

#import "CustomActivityIndicatorView.h"
#import <QuartzCore/CALayer.h>

#define SELF_WIDHT        100.0
#define SELF_HIGHT        90.0

#define activityView_WIDHT 40.0
#define activityView_HIGHT 40.0
#define activityView_TOP_MARGIN 25.0

@implementation CustomActivityIndicatorView

+ (id)loadingViewWithMessageText:(NSString *) msgText {
   
    CustomActivityIndicatorView *activityView = [[[CustomActivityIndicatorView alloc] initWithFrame:CGRectMake((320.0f-SELF_WIDHT)/2.0f, (460.0f-SELF_HIGHT)/2.0f, SELF_WIDHT, SELF_HIGHT)] autorelease];
    
	if (activityView) {
		
		//[activityView setBackgroundColor:[UIColor blackColor]];
        [activityView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.85]];
        
        // Initialization code.
		
		//Create the first status image and the indicator view
		UIImage *statusImage = [UIImage imageNamed:@"status1.png"];
		UIImageView *activityImageView = [[UIImageView alloc] 
										  initWithFrame:CGRectMake((SELF_WIDHT-activityView_WIDHT)/2.0f, activityView_TOP_MARGIN, activityView_WIDHT, activityView_HIGHT)];
		[activityImageView setImage:statusImage];
        	
		float yPos = activityView_TOP_MARGIN+activityView_HIGHT+2.0;
		float hight = SELF_HIGHT - yPos - 2.0; 
		UILabel *loadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(2.0,yPos,SELF_WIDHT-4.0,hight)];
		[loadingLabel setText:msgText];
		[loadingLabel setNumberOfLines:3];
		[loadingLabel setFont:fontHelvetica14];
		[loadingLabel setTextAlignment:UITextAlignmentCenter];
		[loadingLabel setTextColor:[UIColor whiteColor]];
		[loadingLabel setBackgroundColor:[UIColor clearColor]];
 		//[activityView addSubview:loadingLabel];
		[loadingLabel release];
		
		NSArray *imagearray = [NSArray arrayWithObjects:
							   [UIImage imageNamed:@"status1.png"],
							   [UIImage imageNamed:@"status2.png"],
                               [UIImage imageNamed:@"status3.png"],
                               [UIImage imageNamed:@"status4.png"],
                               [UIImage imageNamed:@"status5.png"],
                               [UIImage imageNamed:@"status6.png"],
                               [UIImage imageNamed:@"status7.png"],
                               [UIImage imageNamed:@"status8.png"],
							   nil];
		
		activityView.layer.cornerRadius=10.0;
		//Set the duration of the animation (play with it
		//until it looks nice for you)
		activityImageView.animationDuration = 0.8;
//		[activityView setAlpha:0.7];
		
		[activityView.layer setMasksToBounds:YES];
		[activityView.layer setBorderWidth:1.0];
		[activityView.layer setBorderColor:[[UIColor colorWithWhite:0.0 alpha:0.2]CGColor]];
		
		//Add more images which will be used for the animation
		activityImageView.animationImages = imagearray;
		[activityImageView startAnimating];
		
		
		//Add your custom activity indicator to your current view
		[activityView addSubview:activityImageView];
		[activityImageView release];
        
	}	
  
    return activityView;
}

+ (id)loadingView {
    
    CustomActivityIndicatorView *activityView = [[[CustomActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0 , 37, 37)] autorelease];
    
	if (activityView) {
		
        [activityView setBackgroundColor:[UIColor clearColor]];
        
        // Initialization code.
		
		//Create the first status image and the indicator view
		UIImage *statusImage = [UIImage imageNamed:@"status1.png"];
		UIImageView *activityImageView = [[UIImageView alloc] 
										  initWithFrame:CGRectMake(0, 10, 37, 37)];
		[activityImageView setImage:statusImage];
	
		NSArray *imagearray = [NSArray arrayWithObjects:
							   [UIImage imageNamed:@"status1.png"],
							   [UIImage imageNamed:@"status2.png"],
                               [UIImage imageNamed:@"status3.png"],
                               [UIImage imageNamed:@"status4.png"],
                               [UIImage imageNamed:@"status5.png"],
                               [UIImage imageNamed:@"status6.png"],
                               [UIImage imageNamed:@"status7.png"],
                               [UIImage imageNamed:@"status8.png"],
							   nil];
		
		//activityView.layer.cornerRadius=10.0;
		//Set the duration of the animation (play with it
		//until it looks nice for you)
		activityImageView.animationDuration = 0.8;
		
		//Add more images which will be used for the animation
		activityImageView.animationImages = imagearray;
		[activityImageView startAnimating];
		
		
		//Add your custom activity indicator to your current view
		[activityView addSubview:activityImageView];
		[activityImageView release];
        
	}	
    
    return activityView;
}

+(id)loadingProgressBarWithText:(NSString *) progressCount {
    CustomActivityIndicatorView *activityView = [[[CustomActivityIndicatorView alloc] initWithFrame:CGRectMake((320.0f-SELF_WIDHT-30)/2.0f, (460.0f-SELF_HIGHT+30)/2.0f, SELF_WIDHT+30, SELF_HIGHT+30)] autorelease];
   
	if (activityView) {
		
		[activityView setBackgroundColor:[UIColor blackColor]];
        // Initialization code.
		
		//Create the first status image and the indicator view
		UIImage *statusImage = [UIImage imageNamed:@"status1.png"];
		UIImageView *activityImageView = [[UIImageView alloc] 
										  initWithFrame:CGRectMake((SELF_WIDHT+30-activityView_WIDHT)/2.0f, activityView_TOP_MARGIN, activityView_WIDHT, activityView_HIGHT)];
		[activityImageView setImage:statusImage];
        
		float yPos = activityView_TOP_MARGIN+activityView_HIGHT+2.0;
		float hight = SELF_HIGHT - yPos - 2.0; 
		UILabel *loadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(4.0,yPos+33,SELF_WIDHT+20,hight)];
		[loadingLabel setText:@"Uploading..."];
		[loadingLabel setNumberOfLines:3];
		[loadingLabel setFont:fontHelvetica14];
		[loadingLabel setTextAlignment:UITextAlignmentCenter];
		[loadingLabel setTextColor:[UIColor whiteColor]];
		[loadingLabel setBackgroundColor:[UIColor clearColor]];
 		[activityView addSubview:loadingLabel];
		[loadingLabel release];
        
        
        UILabel *percentLoadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(4.0,yPos,SELF_WIDHT+20,hight)];
		[percentLoadingLabel setText:[NSString stringWithFormat:@"%@%% Complete",progressCount]];
		[percentLoadingLabel setNumberOfLines:3];
		[percentLoadingLabel setFont:fontHelvetica14];
		[percentLoadingLabel setTextAlignment:UITextAlignmentCenter];
		[percentLoadingLabel setTextColor:[UIColor whiteColor]];
		[percentLoadingLabel setBackgroundColor:[UIColor clearColor]];
 		[activityView addSubview:percentLoadingLabel];
		[percentLoadingLabel release];
		        
		NSArray *imagearray = [NSArray arrayWithObjects:
							   [UIImage imageNamed:@"status1.png"],
							   [UIImage imageNamed:@"status2.png"],
                               [UIImage imageNamed:@"status3.png"],
                               [UIImage imageNamed:@"status4.png"],
                               [UIImage imageNamed:@"status5.png"],
                               [UIImage imageNamed:@"status6.png"],
                               [UIImage imageNamed:@"status7.png"],
                               [UIImage imageNamed:@"status8.png"],
							   nil];
		
		activityView.layer.cornerRadius=10.0;
		//Set the duration of the animation (play with it
		//until it looks nice for you)
		activityImageView.animationDuration = 0.8;
		[activityView setAlpha:0.7];
		
		[activityView.layer setMasksToBounds:YES];
		[activityView.layer setBorderWidth:3.0];
		[activityView.layer setBorderColor:[[UIColor colorWithWhite:1.0 alpha:1.0]CGColor]];
		
		//Add more images which will be used for the animation
		activityImageView.animationImages = imagearray;
		[activityImageView startAnimating];
		
		//Progress Bar 
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.frame = CGRectMake(4.0,yPos+25,SELF_WIDHT+20,hight);
        float currentVal=[progressCount floatValue];
        
        if ((currentVal/100.0)>=1.0) {
            [progressView setProgress:0.0];
            
        }else{
            [progressView setProgress:currentVal/100.0];
        }
        
        [activityView addSubview:progressView];
        [progressView release];
		//Add your custom activity indicator to your current view
		[activityView addSubview:activityImageView];
		[activityImageView release];
        
	}	
     
    return activityView;



}
- (void)dealloc {
    [super dealloc];
}


@end
