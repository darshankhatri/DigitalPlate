//
//  Created by user on 07/12/11.
//  Copyright 2012 iDroid. All rights reserved.
//

#import "faceBook.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"


#define FB_APP_ID	@"186266485231"

@implementation faceBook

@synthesize _accessToken;
@synthesize _webView;
@synthesize strMsg;
@synthesize _delegate;
@synthesize btnBack;
@synthesize imageFB;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		//self._webView = [[UIWebView alloc] initWithFrame:frame];
		
        
		[self setBackgroundColor:[UIColor blackColor]];
		
		self._webView = [[UIWebView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
		btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnBack setFrame:CGRectMake(10,10, 106, 41)];
		[btnBack setBackgroundImage:[UIImage imageNamed:@"acr-skin.1.2.button-main-off.png"] forState:UIControlStateNormal];
		[btnBack setTitle:@"Back" forState:UIControlStateNormal];
		[btnBack addTarget:self action:@selector(callToBack) forControlEvents:UIControlEventTouchUpInside];
		//[self addSubview:btnBack];
		[self addSubview:self._webView];
		self._delegate = _delegate;
		[self._webView setDelegate:self];
    }
    return self;
}

-(void)callToBack
{
	//[self setHidden:TRUE];

}

-(void)login
{
	
	 NSString *permissions = @"publish_stream";
	
	[_webView loadRequest:
	 [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
	
    NSString *redirectUrlString = 
	@"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
	
    NSString *urlString = [NSString stringWithFormat:authFormatString, 
						   FB_APP_ID, redirectUrlString, permissions];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	NSLog(@"shouldStartLoadWithRequest");
	
    NSString *urlString = request.URL.absoluteString;
	
    [self checkForAccessToken:urlString];    
    [self checkLoginRequired:urlString];
	
    return TRUE;
}

-(void)checkForAccessToken:(NSString *)urlString {
	
	NSLog(@"checkForAccessToken");
	
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression 
								  regularExpressionWithPattern:@"access_token=(.*)&" 
								  options:0 error:&error];
    if (regex != nil) {
		
		
        NSTextCheckingResult *firstMatch = 
		[regex firstMatchInString:urlString 
						  options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {

            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken 
						   stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

			[self accessTokenFound:accessToken];
        }
    }
}

- (void)accessTokenFound:(NSString *)accessToken {

	NSLog(@"accessTokenFound");
	
	_accessToken = [[NSString alloc] initWithString:accessToken];
	[_delegate removeViewDialogue];
	//[self postOnWall];
    [self postOnWallwithImage];
}

-(void)checkLoginRequired:(NSString *)urlString {
	NSLog(@"checkLoginRequired");
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound) {
		NSLog(@"checkLoginRequired 1");
        DigitalPlateAppDelegate *delegate = (DigitalPlateAppDelegate *) [[UIApplication sharedApplication] delegate];
        [delegate stopActivityIndicator];
		[_delegate displayRequired];
    }
	else {
		NSLog(@"checkLoginRequired 2");

	}

}

-(void)postOnWallwithImage {
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];  
	
	if([defaults valueForKey:@"fbData"] == nil)
	{
		NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
		NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
		
		NSString *tokenString  = [NSString stringWithFormat:@"%@",[headers valueForKey:@"Cookie"]];
		NSArray *tokenArray = [tokenString componentsSeparatedByString:@";"];
		NSString *userName = nil;
        
		for(NSString *tokenFromString in tokenArray)
		{
			tokenFromString = [tokenFromString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if([tokenFromString hasPrefix:@"m_user"])
			{
				userName=[tokenFromString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				
				if([[userName componentsSeparatedByString:@":"] count] > 1) {
					userName=[[userName componentsSeparatedByString:@":"] objectAtIndex:0];
					userName=[[userName componentsSeparatedByString:@"="] objectAtIndex:1];
				}
				NSLog(@"FB USER NAME=%@",userName);
			}
		}
		
		[defaults setValue:userName forKey:@"fbData"];
		
		[defaults synchronize];
		NSLog(@"FB TEST=%@",[defaults valueForKey:@"fbData"]);
		
	}
	
    
    NSRange r = [_accessToken rangeOfString:@"&"];
    if (r.location!=NSNotFound)
        _accessToken=[_accessToken substringToIndex:r.location];
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    //[newRequest addFile:filePath forKey:@"file"];
    [newRequest addData:self.imageFB forKey:@"source"];    
    [newRequest setPostValue:self.strMsg forKey:@"message"];
    [newRequest setPostValue:_accessToken forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(sendToPhotosFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];

}

-(void)postOnWall
{
	NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];  
	
	if([defaults valueForKey:@"fbData"] == nil)
	{
		NSArray * availableCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
		NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookies];
		
		NSString *tokenString  = [NSString stringWithFormat:@"%@",[headers valueForKey:@"Cookie"]];
		NSArray *tokenArray = [tokenString componentsSeparatedByString:@";"];
		NSString *userName = nil;

		for(NSString *tokenFromString in tokenArray)
		{
			tokenFromString = [tokenFromString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			if([tokenFromString hasPrefix:@"m_user"])
			{
				userName=[tokenFromString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				
				if([[userName componentsSeparatedByString:@":"] count] > 1) {
					userName=[[userName componentsSeparatedByString:@":"] objectAtIndex:0];
					userName=[[userName componentsSeparatedByString:@"="] objectAtIndex:1];
				}
				NSLog(@"FB USER NAME=%@",userName);
			}
		}
		
		[defaults setValue:userName forKey:@"fbData"];
		
		[defaults synchronize];
		NSLog(@"FB TEST=%@",[defaults valueForKey:@"fbData"]);
		
	}
	
			
	 NSRange r = [_accessToken rangeOfString:@"&"];
	 if (r.location!=NSNotFound)
	 _accessToken=[_accessToken substringToIndex:r.location];
	 
	 
	 NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
	 
	 ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
	 [newRequest setPostValue:self.strMsg forKey:@"message"];
	 //  [newRequest setPostValue:@"hi" forKey:@"name"];
	 //  [newRequest setPostValue:@"aaa" forKey:@"description"];
	 [newRequest setPostValue:_accessToken forKey:@"access_token"];
	 [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
	 [newRequest setRequestMethod:@"POST"];
	 
	 [newRequest setDelegate:self];
	 [newRequest startAsynchronous];
}

-(void)sendToPhotosFinished:(ASIHTTPRequest *)request {
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];

    if(postId != nil)
	{
		[_delegate FBStatusMsg:@"Sucessfully posted Check out your Facebook to see!"];
		
	}
	else {
        
		[_delegate FBStatusMsg:@"There is an Error while posting. Please try again."];
	}

}

- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];

    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];

	if(postId != nil)
	{
		[_delegate FBStatusMsg:@"Sucessfully posted Check out your Facebook to see!"];
		
	}
	else {

		[_delegate FBStatusMsg:@"There is an Error while posting. Please try again."];
	}

}



- (void)dealloc {
	//self._accessToken = nil;
	//self._webView = nil;
	//self.strMsg = nil;
	//self._delegate = nil;
	//self.btnBack= nil;
    [imageFB release];
    [super dealloc];
}


@end
