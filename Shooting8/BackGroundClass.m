//
//  BackGroundClass.m
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//
//#define TEST
#import "BackGroundClass.h"
#import "UIView+Animation.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation BackGroundClass
@synthesize wType;

-(id)init{
    self = [self init:0 width:320 height:480];
    
    return self;
}
-(id)init:(WorldType)_type width:(int)width height:(int)height{
    self = [super init];
    y_loc = 0;
    
    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, y_loc, width, height)];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, y_loc - height, width, height)];
    
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
            iv_background1.image = [UIImage imageNamed:@"back_forest.png"];
            iv_background2.image = [UIImage imageNamed:@"back_forest.png"];
            break;
        }
    }
//#endif

    //ここでアニメーションスタートさせても目的地をセットするための(貼付けられるべき)スーパービューが設定されていない

    [iv_background1 moveTo:CGPointMake(0, height + 10)
                  duration:3.0f
                    option:UIViewAnimationOptionCurveLinear];//一定速度
    
    [iv_background2 moveTo:CGPointMake(0, height + 10)
                  duration:6.0f
                    option:UIViewAnimationOptionCurveLinear];//一定速度
    return self;
}





-(void)doNext{
    
    CALayer *mLayer = [iv_background1.layer presentationLayer];
    y_loc = mLayer.position.y;
    
#ifdef TEST
    NSLog(@"y = %d", y_loc);
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
