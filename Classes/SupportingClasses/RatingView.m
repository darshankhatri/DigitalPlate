//
//  RatingView.m
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import "RatingView.h"


@implementation RatingView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        for(int i=1; i<=5; i++) {
            UIButton *btnRating = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnRating setImage:[UIImage imageNamed:@"EmptyStarRatingOnSave.png"] forState:UIControlStateNormal];
            [btnRating addTarget:self action:@selector(changeRating:) forControlEvents:UIControlEventTouchUpInside];
            [btnRating setFrame:CGRectMake(((i-1)*18), 0, 15, 15)];
            [btnRating setCenter:CGPointMake(btnRating.center.x, self.frame.size.height/2)];
            [btnRating setTag:i];
            [self addSubview:btnRating];
        }
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	
    NSLog(@"...drawRect");
    
	/*for(int i=1; i<=5; i++) {
		UIButton *btnRating = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRating setImage:[UIImage imageNamed:@"EmptyStarRatingOnSave.png"] forState:UIControlStateNormal];
		[btnRating addTarget:self action:@selector(changeRating:) forControlEvents:UIControlEventTouchUpInside];
		[btnRating setFrame:CGRectMake(((i-1)*18), 0, 15, 15)];
		[btnRating setCenter:CGPointMake(btnRating.center.x, rect.size.height/2)];
		[btnRating setTag:i];
		[self addSubview:btnRating];
	}*/
}

-(void)changeRating:(id)sender {
	
	for (int i=1; i<=5; i++) {
			
		UIButton *btnRating = (UIButton *)[self viewWithTag:i];
		
		if([btnRating tag] <= [sender tag]) {
			[btnRating setImage:[UIImage imageNamed:@"FullStarRatingOnSave.png"] forState:UIControlStateNormal];
		}
		else {
			[btnRating setImage:[UIImage imageNamed:@"EmptyStarRatingOnSave.png"] forState:UIControlStateNormal];
		}
	}
	
	if(_delegate!=nil) {
		[_delegate changedRating:[sender tag]];
	}
}


-(void)setRating:(int)rating {
	
    NSLog(@"...setRating");
    
	for (int i=1; i<=5; i++) {
		
		UIButton *btnRating = (UIButton *)[self viewWithTag:i];
		if([btnRating tag] <= rating) {
			[btnRating setImage:[UIImage imageNamed:@"FullStarRatingOnSave.png"] forState:UIControlStateNormal];
		}
		else {
			[btnRating setImage:[UIImage imageNamed:@"EmptyStarRatingOnSave.png"] forState:UIControlStateNormal];
		}
	}
	
	if(_delegate!=nil) {
		[_delegate changedRating:rating];
	}
	
}


- (void)dealloc {
	self.delegate = nil;
    [super dealloc];
}


@end
