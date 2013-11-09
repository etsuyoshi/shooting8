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
    
    //つなぎ目Check@静止画:テスト用=>startAnimationの内容をコメントアウトして停止
//    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize/2, width, originalFrameSize)];
//    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  originalFrameSize/2, width, originalFrameSize)];
//    y_loc1 = iv_background1.bounds.origin.y;
//    y_loc2 = iv_background2.bounds.origin.y;
    y_loc1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
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

-(void)startAnimation:(float)secs{
    
    [UIView animateWithDuration:secs
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear//constant-speed
                     animations:^{
                         iv_background1.center =
                            CGPointMake(iv_background1.bounds.size.width/2,
                                        iv_background1.center.y + originalFrameSize);
                         iv_background2.center =
                            CGPointMake(iv_background2.bounds.size.width/2,
                                        iv_background2.center.y + originalFrameSize);
                     }
                     completion:^(BOOL finished){
                         //初期化
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
                         
                         [self startAnimation:secs];
                     }];
}



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
