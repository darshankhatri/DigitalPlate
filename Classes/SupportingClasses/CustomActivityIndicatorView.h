//
//  CustomActivityIndicatorView.h
//  CustomActivityIndicator
//
//  Created by RupakParikh on 09/12/10.
//  Copyright 2010 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomActivityIndicatorView : UIView {
	
}
+(id)loadingView;
+(id)loadingViewWithMessageText:(NSString *) msgText;
+(id)loadingProgressBarWithText:(NSString *) progressCount;
@end
