
//  Created by user on 06/12/11.
//  Copyright 2012 iDroid. All rights reserved.
//

#import "Twitter.h"
#import "SA_OAuthTwitterEngine.h"
#import <QuartzCore/QuartzCore.h>


#define kOAuthConsumerKey        @"aZ5KBDPEVuLQrH3zeLHjw"         //REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret     @"sm0Afqr53PfPWtKwXU7nBsPJo35CEU84Hpwd5k4" 

@implementation Twitter

@synthesize delegate;
@synthesize controllerDelegate;
@synthesize strAlbumNm;

- (id)initWithFrame:(CGRect)frame :(NSString *)albumName{
	
	self.strAlbumNm=albumName;
    
	NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
		
	NSString *userName = nil;
	
	if([defaults objectForKey:@"authData"] != nil)
	{
		NSString *tokenString  = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"authData"]];
		NSArray *tokenArray = [tokenString componentsSeparatedByString:@"&"];
		for(NSString *tokenFromString in tokenArray)
		{
			if([tokenFromString hasPrefix:@"screen_name"])
				userName=[[tokenFromString componentsSeparatedByString:@"="] objectAtIndex:1];
		}
	}
		
	 
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		//UIAlertView *alrtTwitter = [[UIAlertView alloc] initWithTitle:@"Post Tweet" message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
		UIAlertView *alrtTwitter;
		if([userName isEqualToString:@""] || userName == nil)
			alrtTwitter = [[UIAlertView alloc] initWithTitle:@"Post Tweet" message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
		else {
			alrtTwitter = [[UIAlertView alloc] initWithTitle:userName message:@"\n\n\n" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
		}

		
		tweetTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 65)];
		[tweetTextField becomeFirstResponder];
        [tweetTextField.layer setCornerRadius:5.0];        
		[tweetTextField setBackgroundColor:[UIColor whiteColor]];
		//if(userName != nil && self.strAlbumNm !=nil)
//			tweetTextField.text=[[userName stringByAppendingString:@" Like "] stringByAppendingString:strAlbumNm];
//		else
//			tweetTextField.text=@"";
		
		if(self.strAlbumNm !=nil)
			tweetTextField.text=strAlbumNm;
		else
			tweetTextField.text=@"";
		
		tweetTextField.textAlignment=UITextAlignmentLeft;
		[alrtTwitter addSubview:tweetTextField];
		[alrtTwitter show];
		[alrtTwitter release];
    }
    return self;
}

#pragma mark -
#pragma mark AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons

	if (buttonIndex == 0)
	{

		if(!_engine){  
			_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
			_engine.consumerKey    = kOAuthConsumerKey;  
			_engine.consumerSecret = kOAuthConsumerSecret;  
		}  
		
		if(![_engine isAuthorized]){  
			
			UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
			
			if (controller){  
				[controllerDelegate presentModalViewController: controller animated: YES];  

			}  
		}
		else {
			[_engine sendUpdate:[tweetTextField.text stringByReplacingOccurrencesOfString:@"You " withString:@""]];
		}

		
	}
	
}

#pragma mark SA_OAuthTwitterEngineDelegate  
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
	
	
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
	
    [defaults setObject: data forKey: @"authData"];  
   // [defaults synchronize];
	[self performSelector:@selector(updateTwitter:) withObject:nil afterDelay:1.0];

}  

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {  
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];  
}  

-(void)updateTwitter:(id)sender
{
	[_engine sendUpdate:[tweetTextField.text stringByReplacingOccurrencesOfString:@"You Like" withString:@"Likes "]];
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
	
	UIAlertView *alertViewTWMsg = [[[UIAlertView alloc] 
									initWithTitle:@"" 
									message:@"Successfully tweeted. Checkout your tweeter to see."
									delegate:nil 
									cancelButtonTitle:@"OK"
									otherButtonTitles:nil] autorelease];
	[alertViewTWMsg show];
	
	//[self.navigationController popViewControllerAnimated:TRUE];
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
	
	UIAlertView *alertViewTWMsg = [[[UIAlertView alloc] 
									initWithTitle:@"" 
									message:@"There is some prob to tweet. Please try again."
									delegate:nil 
									cancelButtonTitle:@"OK"
									otherButtonTitles:nil] autorelease];
	[alertViewTWMsg show];
	
	
}  

-(void)cancel:(id)sender
{
	//[self.navigationController popViewControllerAnimated:TRUE];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.strAlbumNm=nil;
    [super dealloc];
}


@end
