
//  Created by user on 06/12/11.
//  Copyright 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;

@interface Twitter : UIView <UITextFieldDelegate, SA_OAuthTwitterControllerDelegate> {

	SA_OAuthTwitterEngine    *_engine;
	
	id delegate;
	
	id controllerDelegate;
	
	UITextField *tweetTextField;
	NSString *strAlbumNm;
}

@property(nonatomic, retain) UITextField *tweetTextField;  
@property(nonatomic, retain) id delegate;
@property(nonatomic, retain) id controllerDelegate;
@property(nonatomic, retain) NSString *strAlbumNm;

- (id)initWithFrame:(CGRect)frame :(NSString *)albumName;
-(IBAction)updateTwitter:(id)sender;
-(IBAction)cancel:(id)sender;

@end
