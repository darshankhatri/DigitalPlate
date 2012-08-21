//
//  AddFriendViewController.h
//  DigitalPlate
//
//  Created by iDeveloper on 3/14/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendViewController : UIViewController<UITextFieldDelegate> {
    
    UITextField *fbNameTextfield;
    UITextField *emailTextField;
}

@property(nonatomic, retain) IBOutlet UITextField *fbNameTextfield;
@property(nonatomic, retain) IBOutlet UITextField *emailTextField;

-(IBAction)searchButtonClicked:(id)sender;
@end
