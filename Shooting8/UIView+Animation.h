//
//  UIView+Animation.h
//  UIAnimationSamples
//
//  Created by 遠藤 豪 on 2013/11/02.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)
- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;

-(void) moveBoundDuration:(float)secs
                   option:(UIViewAnimationOptions)option;

-(void) moveDownDuration:(float)secs
                  option:(UIViewAnimationOptions)option;
-(void) moveUpDuration:(float)secs
                  option:(UIViewAnimationOptions)option;
-(void) oscillate:(float)secs
           option:(UIViewAnimationOptions)option;
@end
