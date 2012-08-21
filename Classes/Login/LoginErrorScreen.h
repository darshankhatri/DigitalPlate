//
//  LoginErrorScreen.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/12/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginErrorScreen : UIViewController
{
    UIButton *reEnterData;
    UIButton *reSetPassword;
}

@property(nonatomic, retain) IBOutlet UIButton *reEnterData;
@property(nonatomic, retain) IBOutlet UIButton *reSetPassword;

- (IBAction)reEnterLoginData:(id)sender;
- (IBAction)resetPasswordDetail:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;

@end
