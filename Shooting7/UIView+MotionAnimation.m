//
//  MotionAnimation.m
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "UIView+MotionAnimation.h"

@implementation UIView (Animation)
- (void) moveTo:(CGPoint)destination
       duration:(float)secs
         option:(UIViewAnimationOptions)option
{
    //このメソッドはUIViewの全てのインスタンスを今現在の位置から新しい目的地まで１秒(float)で移動させます。
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:nil];
}
