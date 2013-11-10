//
//  Effect.m
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/10.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "Effect.h"

@implementation Effect{
    int effectDuration;
    UIView *viewEffect;
    CGRect rectEffect;
}

//@synthesize effectType;

-(id)initWithFrame:(CGRect)_rect{
    self = [super init];
    effectDuration = 0;
    rectEffect = _rect;
    viewEffect = [[UIView alloc]initWithFrame:rectEffect];
//    [viewEffect setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.6f]];
//    viewEffect.center = CGPointMake(rectEffect.size.width/2,
//                                    rectEffect.size.height/2);
//    viewEffect.image = [UIImage imageNamed:@"powerGauge2.png"];
    return self;
}
-(UIView *)getEffectView:(EffectType)_effectType{
    NSLog(@"getEffect");
    switch (_effectType) {
        case EffectTypeStandard:{
            [self occurEffect:10];
            break;
        }
        case EffectTypeHeal:{
            
            break;
        }
        default:
            break;
    }
    return viewEffect;
}

-(void)occurEffect:(int)duration{//standard
    
    //領域と枠を別々にアニメーションを実行
    NSLog(@"occurEffect");
    //http://stackoverflow.com/questions/10669051/how-do-i-create-a-smoothly-resizable-circular-uiview
    int diameter = 100;
    CGFloat animationDuration = 0.5f; // Your duration
    CGFloat animationDelay = 0; // Your delay (if any)
    
    UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30,
                                                              diameter,
                                                              diameter)];
    circle.image = [UIImage imageNamed:@"powerGauge2.png"];
    circle.center = viewEffect.center;
//    circle.layer.cornerRadius=diameter/2;
    //cyan
    [[circle layer] setBorderColor:[[UIColor colorWithRed:0
                                                    green:1
                                                     blue:1
                                                    alpha:0.3f] CGColor]];
    [[circle layer] setBorderWidth:1.0];//boarder
    [[circle layer] setBackgroundColor:[UIColor colorWithRed:0
                                                       green:1
                                                        blue:1
                                                       alpha:0.5f].CGColor];
    
    
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    [cornerRadiusAnimation setFromValue:[NSNumber numberWithFloat:diameter/2]]; // The current value
    [cornerRadiusAnimation setToValue:[NSNumber numberWithFloat:10.0]]; // The new value
    [cornerRadiusAnimation setDuration:animationDuration];
    [cornerRadiusAnimation setBeginTime:CACurrentMediaTime() + animationDelay];
    [cornerRadiusAnimation setRepeatCount:duration];
    
    // If your UIView animation uses a timing funcition then your basic animation needs the same one
    [cornerRadiusAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // This will keep make the animation look as the "from" and "to" values before and after the animation
    [cornerRadiusAnimation setFillMode:kCAFillModeBoth];
    [[circle layer] addAnimation:cornerRadiusAnimation forKey:@"keepAsCircle"];
    [[circle layer] setCornerRadius:10.0]; // Core Animation doesn't change the real value so we have to.
    
    [UIView animateWithDuration:animationDuration
                          delay:animationDelay
                        options:UIViewAnimationOptionCurveEaseInOut
     //                                |UIViewAnimationOptionRepeat
                     animations:^{
                         [UIView setAnimationRepeatCount: duration];
                         [[circle layer] setFrame:CGRectMake(50, 50, 20, 20)]; // Arbitrary frame ...
                         //                         circle.layer.frame = CGRectMake(50, 50, 0, 0);
                         circle.center = CGPointMake(viewEffect.frame.size.width/2,
                                                     viewEffect.frame.size.height/2);//viewEffect.center;//
                         [[circle layer] setBackgroundColor:[[UIColor colorWithRed:0
                                                                              green:1
                                                                               blue:1
                                                                              alpha:0.5f] CGColor]];
                         // You other UIView animations in here...
                     } completion:^(BOOL finished) {
                         // Maybe you have your completion in here...
//                         [circle removeFromSuperview];
                         [viewEffect removeFromSuperview];
                     }];
    
    [viewEffect addSubview:circle];
    
//    [UIView animateWithDuration:3.5f
//                          delay:0.0f
//                        options:UIViewAnimationOptionRepeat
//                     animations:^{
//                         [UIView setAnimationRepeatCount: 3.0];
//                         viewEffect.bounds = CGRectMake(0, 0, 1, 1);//半径小さく
//                         viewEffect.alpha = 0;
////                         viewEffect.center = CGPointMake(0, 0);
//                     }
//                     completion:^(BOOL finished){
//                         viewEffect.image = [UIImage imageNamed:@"powerGauge2.png"];
//                         NSLog(@"finished %d", effectDuration);
//                         effectDuration++;
////                         if(effectDuration<duration){
////                             [self occurEffect:duration];
////                         }else{
////                             effectDuration=0;//initialization
////                             [viewEffect removeFromSuperview];
////                         }
//                     }];
}
@end
