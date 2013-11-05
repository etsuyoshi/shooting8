//
//  BackGroundClass.m
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//
#define TEST
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
    originalFrameSize = height;//フレーム縦サイズ
    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, originalFrameSize + 10)];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize, width, originalFrameSize + 10)];
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
            iv_background1.image = [UIImage imageNamed:@"back_forest.png"];
            iv_background2.image = [UIImage imageNamed:@"back_forest.png"];
            break;
        }
    }
//#endif

    return self;
}





-(void)doNext{
    
//    CALayer *mLayer = [iv_background1.layer presentationLayer];
    //現在中心座標
    y_loc1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
    
    if(y_loc1 < 0){//通常ルーチン:y_loc1==-iv_background1.bounds.size.height/2
        [iv_background1 moveTo:CGPointMake(0, originalFrameSize)//origin
                      duration:10.0f
                        option:UIViewAnimationOptionCurveLinear];
    }else if(y_loc1 <= originalFrameSize /2){//初期状態では１の中心が画面の中心に位置しているので速さは半分
        [iv_background1 moveTo:CGPointMake(0, originalFrameSize)//origin
                      duration:5.0f
                        option:UIViewAnimationOptionCurveLinear];
    }
    if(y_loc2 <= 0){//y_loc2==-iv_background2.bounds.size.height/2){
        [iv_background2 moveTo:CGPointMake(0, originalFrameSize)//origin
                      duration:10.0f
                        option:UIViewAnimationOptionCurveLinear];
    }
    
    if(y_loc1 >= iv_background1.bounds.size.height * 3 / 2){//最後まで描画されたら
        
        iv_background1.frame = CGRectMake(0, -originalFrameSize,
                                          iv_background1.bounds.size.width,
                                          originalFrameSize + 10);
        
    }
    
    if(y_loc2 >= iv_background2.bounds.size.height * 3 / 2){//最後まで描画されたら
        iv_background2.frame = CGRectMake(0, -originalFrameSize,
                                          iv_background2.bounds.size.width + 5,
                                          originalFrameSize + 10);
        
    }
    
#ifdef TEST
    NSLog(@"y1 = %f", iv_background1.bounds.origin.y);
    NSLog(@"y2 = %f", iv_background2.bounds.origin.y);
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
