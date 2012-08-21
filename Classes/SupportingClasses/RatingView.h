//
//  RatingView.h
//  DigitalPlate
//
//  Created by iDroid on 18/03/12.
//  Copyright 2012 iDroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RatingViewDelegate
	@required
	-(void)changedRating:(int)rating;
@end


@interface RatingView : UIView {
	id <RatingViewDelegate> _delegate;
}

@property (nonatomic, assign) id <RatingViewDelegate> delegate;

-(void)setRating:(int)rating;

@end
