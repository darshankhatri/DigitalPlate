//
//  Created by user on 07/12/11.
//  Copyright 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceBookDelegate

- (void)displayRequired;
-(void)FBStatusMsg:(NSString *)status;
-(void)removeViewDialogue;

@end

@interface faceBook : UIView <UIWebViewDelegate> {
	
	NSString *_accessToken;
	UIWebView *_webView;
	NSString *strMsg;
	id <FaceBookDelegate> _delegate;
	UIButton *btnBack;
    NSData *imageFB;

}
@property (nonatomic,retain) NSString *_accessToken;
@property (nonatomic, retain) UIWebView *_webView;
@property (nonatomic, retain) NSString *strMsg;
@property (assign) id <FaceBookDelegate> _delegate;
@property (nonatomic, retain) UIButton *btnBack;
@property (nonatomic, retain) NSData *imageFB;

- (id)initWithFrame:(CGRect)frame ;
-(void)login;
-(void)checkForAccessToken:(NSString *)urlString;
- (void)accessTokenFound:(NSString *)accessToken;
-(void)checkLoginRequired:(NSString *)urlString;
-(void)postOnWall;
-(void)postOnWallwithImage;


@end
