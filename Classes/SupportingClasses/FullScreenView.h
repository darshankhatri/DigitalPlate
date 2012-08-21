//
//  FullScreenView.h
//  DigitalPlate
//
//  Created by iDroid on 3/20/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenView : UIView
{
    UIImageView *imgView;

}
-(void)setFullScreenImage:(UIImage*)img;
@property(nonatomic,retain) UIImageView *imgView;
@end
