//
//  BackGroundClass.m
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.

//#define TEST
#import "BackGroundClass.h"
#import "UIView+Animation.h"

@implementation BackGroundClass
@synthesize wType;

int imageMargin;
-(id)init{//引数なしで呼び出された場合のポリモーフィズム
    self = [self init:0 width:320 height:480];
    
    return self;
}
-(id)init:(WorldType)_type width:(int)width height:(int)height{
    self = [super init];
    imageMargin = 20;
    originalFrameSize = height;//フレーム縦サイズ
    
    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, originalFrameSize)];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize,
                                                                  width, originalFrameSize)];
    
    //ゲームやメニュー表示中にホームボタンを押された後、最表示時に再度描画するため
    [self stopAnimation];
    
    //つなぎ目Check@静止画:テスト用=>startAnimationの内容をコメントアウトして停止
//    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize/2, width, originalFrameSize)];
//    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  originalFrameSize/2, width, originalFrameSize)];
//    y_loc1 = iv_background1.bounds.origin.y;
//    y_loc2 = iv_background2.bounds.origin.y;
    y_loc1 = iv_background1.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = iv_background2.center.y;//((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
    NSLog(@"init : yloc1=%d, %f, yloc2=%d, %f", y_loc1, iv_background1.center.y, y_loc2, iv_background2.center.y);
    wType = _type;
    
    //frameの大きさと背景の現在描画位置を決定
    //点数オブジェクトで描画
    
//#ifndef TEST
    switch(wType){
        case WorldTypeUniverse1:{
            //宇宙空間の描画方法
            iv_background1.image = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            iv_background2.image = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            break;
        }
        case WorldTypeUniverse2:{
            //宇宙バージョン
            iv_background1.image = [UIImage imageNamed:@"back_univ.png"];
            iv_background2.image = [UIImage imageNamed:@"back_univ2.png"];
            
            break;
        }
        case WorldTypeNangoku:{
            //南国バージョン
            iv_background1.image = [UIImage imageNamed:@"back_nangoku.png"];
            iv_background2.image = [UIImage imageNamed:@"back_nangoku.png"];
            
            break;
        }
        case WorldTypeSnow:{
            
            //雪山バージョン
            iv_background1.image = [UIImage imageNamed:@"back_snow.png"];
            iv_background2.image = [UIImage imageNamed:@"back_snow.png"];
            
            break;
        }
        case WorldTypeDesert:{
            //砂漠バージョン
            iv_background1.image = [UIImage imageNamed:@"back_desert.png"];
            iv_background2.image = [UIImage imageNamed:@"back_desert.png"];
            
            break;
        }
        case WorldTypeForest:{
            //森バージョン
            iv_background1.image = [UIImage imageNamed:@"back_forest2.png"];
            iv_background2.image = [UIImage imageNamed:@"back_forest2.png"];
            break;
        }
    }
//#endif

    return self;
}

-(void)stopAnimation{
    int x0 = iv_background1.bounds.size.width/2;
    int y0 = originalFrameSize/2;
    NSLog(@"stop animation");
    [UIView animateWithDuration:0.001f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear//constant-speed
                     animations:^{
                         iv_background1.center = CGPointMake(x0, y0);
                         iv_background2.center = CGPointMake(x0, -y0);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"block completion at stop animation");
                         if(finished){
                             NSLog(@"finished stop animation");
                         }
                     }];
}

-(void)startAnimation:(float)secs{
    int y1 = iv_background1.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;
    int x1 = iv_background1.center.x;//((CALayer *)[iv_background1.layer presentationLayer]).position.x;
    int y2 = iv_background2.center.y;//((CALayer *)[iv_background2.layer presentationLayer]).position.y;
    int x2 = iv_background2.center.x;//((CALayer *)[iv_background2.layer presentationLayer]).position.x;
//    NSLog(@"x1=%d, x2=%d, y1=%d, y2=%d, originalFsize=%d", x1, x2, y1, y2, originalFrameSize);
    NSLog(@"start : xC1=%f, xC2=%f, yC1=%f, yC2=%f, originalFrameSize=%d, secs=%f",
          iv_background1.bounds.size.width/2,
          iv_background2.bounds.size.width/2,
          iv_background1.center.y,
          iv_background2.center.y,
          originalFrameSize, secs);
    iv_background1.center = CGPointMake(x1, y1);
    iv_background2.center = CGPointMake(x2, y2);
    
    [UIView animateWithDuration:secs
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear//constant-speed
                     animations:^{
                         iv_background1.center =
                            CGPointMake(x1, y1 + originalFrameSize);

                         iv_background2.center =
                            CGPointMake(x2, y2 + originalFrameSize);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"background animation finished=%@, secs=%f", finished?@"true":@"false", secs);
                         //初期化
                         if(finished){
                             NSLog(@"finished : xC1=%f, xC2=%f, yC1=%f, yC2=%f, originalFrameSize=%d",
                                   iv_background1.bounds.size.width/2,
                                   iv_background2.bounds.size.width/2,
                                   iv_background1.center.y,
                                   iv_background2.center.y,
                                   originalFrameSize);
                             
                             if(iv_background1.center.y > originalFrameSize){
                                 iv_background1.center =
                                 CGPointMake(iv_background1.bounds.size.width/2,
                                             -originalFrameSize/2);
                             }
                             if(iv_background2.center.y > originalFrameSize){
                                 iv_background2.center =
                                 CGPointMake(iv_background2.bounds.size.width/2,
                                             -originalFrameSize/2);
                             }
                             
                             NSLog(@"recursive startAnimation");
                             [self startAnimation:secs];
//                             [self startAnimation:1.0f];
                             
                         }
                     }];
    
    
    
    
}

-(void)oscillateEffect{
    //現在の位置で背景を一旦停止させ、左右に数ピクセル移動を繰り返す
    
//    int y1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;
//    int x1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.x;
//    int y2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;
//    int x2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.x;
//    
//    iv_background1.center = CGPointMake(x1, y1);
//    iv_background2.center = CGPointMake(x2, y2);
//    
//    float _secs = 0.01;
//    [UIView animateWithDuration:_secs
//                     animations:^{
//                         iv_background1.center = CGPointMake(x1 + 10, y1);
//                         iv_background2.center = CGPointMake(x2 + 10, y2);
//                     }
//                     completion:^(BOOL finished){
//                         if(finished){
//                             [UIView animateWithDuration:_secs
//                                              animations:^{
//                                                  iv_background1.center = CGPointMake(x1 - 10, y1);
//                                                  iv_background2.center = CGPointMake(x2 - 10, y2);
//                                              }
//                                              completion:^(BOOL finished){
//                                                  if(finished){
//                                                      [UIView animateWithDuration:_secs
//                                                                       animations:^{
//                                                                           iv_background1.center = CGPointMake(x1 + 10, y1);
//                                                                           iv_background2.center = CGPointMake(x2 + 10, y2);
//                                                                       }
//                                                                       completion:^(BOOL finished){
//                                                                           if(finished){
//                                                                               [UIView animateWithDuration:_secs
//                                                                                                animations:^{
//                                                                                                    iv_background1.center = CGPointMake(x1, y1);
//                                                                                                    iv_background2.center = CGPointMake(x2, y2);
//                                                                                                }
//                                                                                                completion:^(BOOL finished){
//                                                                                                    [self startAnimation:5.0f];
//                                                                                                }];
//                                                                           }
//                                                                       }];
//                                                  }
//                                              }];
//                         }
//                         
//                     }];
    
}

//-(void)moveToPoint:p1{
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//                         iv_background1.center = CGPointMake(x1 - 20, y1);
//                         iv_background2.center = CGPointMake(x2 - 20, y2);
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
//}



/*
 *離散的に呼び出されるdoNext：離散的呼び出しなのでここでアニメーションの繰り返し処理をすれば途切れてしまう
 */
-(void)doNext{
    
//    CALayer *mLayer = [iv_background1.layer presentationLayer];
    //現在中心座標
    y_loc1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
    
    
    
    
#ifdef TEST
    NSLog(@"y1 = %d", y_loc1);
    NSLog(@"y2 = %d", y_loc2);
//    NSLog(@"y1 = %d", y_loc1);
//    NSLog(@"y2 = %d", y_loc2);
#endif
}

-(void)setImage:(NSString *)_imageName{
    _imageName = imageName;
}

-(UIImageView *)getImageView1{
    return iv_background1;
}
-(UIImageView *)getImageView2{
    return iv_background2;
}

@end
