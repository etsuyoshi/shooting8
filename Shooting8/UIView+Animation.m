//
//  UIView+Animation.m
//  UIAnimationSamples
//
//  Created by 遠藤 豪 on 2013/11/02.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
// http://www.raywenderlich.com/ja/29277/uiview%E3%82%A2%E3%83%8B%E3%83%A1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%83%BB%E3%83%81%E3%83%A5%E3%83%BC%E3%83%88%E3%83%AA%E3%82%A2%E3%83%AB-%E5%AE%9F%E8%B7%B5%E3%83%AC%E3%82%B7%E3%83%94

#import "UIView+Animation.h"

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



//bound
-(void) moveBoundDuration:(float)secs
                   option:(UIViewAnimationOptions)option{
    
    //自然な上昇：200px = 0.4sec=>1px = 0.002sec(2msec)=>downに適用
//    [UIView setAnimationRepeatAutoreverses:TRUE]; //最初の位置に戻る
    [UIView animateWithDuration:0.4f
                          delay:0.0f
     options:UIViewAnimationOptionCurveEaseOut//はじめ早く、段々ゆっくりに停止
                     animations:^{
//                         NSLog(@"start    down from bound Method");
                         
                         self.center = CGPointMake(self.center.x,
                                                   self.center.y * 0.2f);
//                                                   (self.center.y - 200 ) < 0? 0:self.center.y - 200);
                         //アニメーションの中でアニメーションをしてしまっているので、
                         //以下のアニメーションは実行されず、最終形態に移行する
//                        [self moveDownDuration:secs
//                                        option:option];
//                         NSLog(@"complete down from bound Method");
                     }
                     completion:^(BOOL finished){
                         
                         if(finished){
//                             NSLog(@"stard    up from bound Method");
                             [self moveDownDuration:secs
                                           option:option];
//                             NSLog(@"complete up from bound Method");
                         }
                     }];
}


-(void) moveUpDuration:(float)secs
                option:(UIViewAnimationOptions)option{
    [UIView animateWithDuration:secs
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
//                         NSLog(@"start    up from up1 Method");
                         self.frame = CGRectMake(0,
                                                 0,
                                                 self.frame.size.width,
                                                 self.frame.size.height);
                         
//                         NSLog(@"complete up from up1 Method");
                     }
                     completion:^(BOOL finished){
//                         NSLog(@"complete up from up2 Method");
                         
                     }];
}



-(void) moveDownDuration:(float)secs//使用しない
                option:(UIViewAnimationOptions)option{

    float destination_y =self.superview.bounds.size.height + 50;
    float _secs = destination_y * 0.002f;//1px = 0.002sec(2msec)
//    NSLog(@"%f, %f", destination_y, _secs);
//    NSLog(@"moveDownDuration:%f option:%d", secs, option);
    [UIView animateWithDuration:_secs
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn//ゆっくりから早く(突然停止)
                     animations:^{
//                         NSLog(@"start down from down1 Method");
//                         self.frame = CGRectMake(300,//self.superview.bounds.size.width - self.frame.size.width,
//                                                 300,//self.superview.bounds.size.height - self.frame.size.height,
//                                                 self.frame.size.width,
//                                                 self.frame.size.height);
                         self.center = CGPointMake(self.center.x,
                                                   destination_y);
//                         NSLog(@"complete down from down1 Method");
                     }
                     completion:^(BOOL finished){
                         
                         if(finished){
//                             NSLog(@"complete down from down2 Method");
                         }
                     }];
}

-(void)oscillate:(float)secs option:(UIViewAnimationOptions)option{
    [UIView setAnimationRepeatAutoreverses:TRUE]; //最初の位置に戻る
    [UIView animateWithDuration:secs
                          delay:0.0f
                        options:option
                     animations:^(void) {
                         self.center = CGPointMake(self.superview.bounds.size.width, self.superview.bounds.size.height);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:secs
                                               delay:0.0f
                                             options:option
                                          animations:^(void) {
                                              self.center = CGPointMake(0, 0);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:secs
                                                                    delay:0.0f
                                                                  options:option
                                                               animations:^(void) {
                                                                   self.center = CGPointMake(300, 300);
                                                               }
                                                               completion:^(BOOL finish) {
                                                                   [UIView animateWithDuration:secs
                                                                                         delay:0.0f
                                                                                       options:option
                                                                                    animations:^(void) {
                                                                                        self.center = CGPointMake(0, 0);
                                                                                    }
                                                                                    completion:^(BOOL finish) {
                                                                                        //nothing
                                                                                    }];
                                                               }
                                               ];
                                          }];
                     }];

}

@end
