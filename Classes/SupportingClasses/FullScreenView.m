//
//  FullScreenView.m
//  DigitalPlate
//
//  Created by iDroid on 3/20/12.
//  Copyright (c) 2012 iDroid. All rights reserved.
//

#import "FullScreenView.h"

@implementation FullScreenView
@synthesize imgView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.imgView = [[UIImageView alloc]initWithFrame:frame];
        [self addSubview:self.imgView];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setFullScreenImage:(UIImage*)img
{
    self.imgView.image = img;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self removeFromSuperview];
}
-(void)dealloc
{
    self.imgView = nil;
}
@end
