//
//  BackGroundClass2.m
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.

//#define TEST
#import "BackGroundClass2.h"
#import "UIView+Animation.h"

@implementation BackGroundClass2
@synthesize wType;
int oscillateWidth = 20;
int imageMargin;
-(id)init{//引数なしで呼び出された場合のポリモーフィズム
    self = [self init:0 width:320 height:480 secs:3];
    
    return self;
}
-(id)init:(WorldType)_type width:(int)width height:(int)height secs:(float)secs{
    oscillateWidth = 5;
    /*速度調整用変数：通常gSecsに従ってanimさせるが、(アイテム取得等の)外部調整によりnewSecsを編集し、適切なタイミングでgSecsとnewSecsが異なるかどうか判定し、異なれば速さを調整(1,2同時に速度調整するため)
     */
    gSecs = secs;
    nowSpeed = 1.0f;
    self = [super init];
    imageMargin = 5;
    originalFrameSize = height;//フレーム縦サイズ
    
    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, 2*originalFrameSize+imageMargin)];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -2*originalFrameSize,
                                                                  width, 2*originalFrameSize+imageMargin)];
    iv_oscillate1 = [[UIImageView alloc]initWithFrame:iv_background1.frame];
    iv_oscillate2 = [[UIImageView alloc]initWithFrame:iv_background2.frame];
    
    //ゲームやメニュー表示中にホームボタンを押された後、最表示時に再度描画するため
//    [self stopAnimation];
    
    //つなぎ目Check@静止画:テスト用=>startAnimationの内容をコメントアウトして停止
    //    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -originalFrameSize/2, width, originalFrameSize)];
    //    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  originalFrameSize/2, width, originalFrameSize)];
    //    y_loc1 = iv_background1.bounds.origin.y;
    //    y_loc2 = iv_background2.bounds.origin.y;
    y_loc1 = iv_background1.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;//center = 240
    y_loc2 = iv_background2.center.y;//((CALayer *)[iv_background2.layer presentationLayer]).position.y;//center = -240
    NSLog(@"init : yloc1=%d, %f, yloc2=%d, %f", y_loc1, iv_background1.center.y, y_loc2, iv_background2.center.y);
    wType = _type;

    UIImage *image1 = nil;
    UIImage *image2 = nil;
    //#ifndef TEST
    switch(wType){
        case WorldTypeUniverse1:{
            //宇宙空間の描画方法
            image1 = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            image2 = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            break;
        }
        case WorldTypeUniverse2:{
            //宇宙バージョン
            image1 = [UIImage imageNamed:@"back_univ.png"];
            image2 = [UIImage imageNamed:@"back_univ2.png"];//attention!
            
            break;
        }
        case WorldTypeNangoku:{
            //南国バージョン
            image1 = [UIImage imageNamed:@"back_nangoku.png"];
            image2 = [UIImage imageNamed:@"back_nangoku.png"];
            
            break;
        }
        case WorldTypeSnow:{
            
            //雪山バージョン
            image1 = [UIImage imageNamed:@"back_snow.png"];
            image2 = [UIImage imageNamed:@"back_snow.png"];
            
            break;
        }
        case WorldTypeDesert:{
            //砂漠バージョン
            image1 = [UIImage imageNamed:@"back_desert.png"];
            image2 = [UIImage imageNamed:@"back_desert.png"];
            
            break;
        }
        case WorldTypeForest:{
            //森バージョン
            image1 = [UIImage imageNamed:@"back_forest2.png"];
            image2 = [UIImage imageNamed:@"back_forest2.png"];
            break;
        }
    }
    //#endif
    
    
    //frameの大きさと背景の現在描画位置を決定
    //点数オブジェクトで描画
    
    UIImageView *subIv_background11 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                                   iv_background1.bounds.size.width,
                                                                                   iv_background1.bounds.size.height/2)];
    UIImageView *subIv_background12 = [[UIImageView alloc]initWithFrame:CGRectMake(0, iv_background1.bounds.size.height/2,
                                                                                   iv_background1.bounds.size.width,
                                                                                   iv_background1.bounds.size.height/2)];
    UIImageView *subIv_background21 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                                   iv_background2.bounds.size.width,
                                                                                   iv_background2.bounds.size.height/2)];
    UIImageView *subIv_background22 = [[UIImageView alloc]initWithFrame:CGRectMake(0, iv_background2.bounds.size.height/2,
                                                                                   iv_background2.bounds.size.width,
                                                                                   iv_background2.bounds.size.height/2)];
    
    UIImageView *subIv_oscillate11 = [[UIImageView alloc]initWithFrame:subIv_background11.frame];
    UIImageView *subIv_oscillate12 = [[UIImageView alloc]initWithFrame:subIv_background12.frame];
    UIImageView *subIv_oscillate21 = [[UIImageView alloc]initWithFrame:subIv_background21.frame];
    UIImageView *subIv_oscillate22 = [[UIImageView alloc]initWithFrame:subIv_background22.frame];
    
    //test:image
//    subIv_background11.image = image1;//[UIImage imageNamed:@"back_nangoku.png"];//image1;
//    subIv_background12.image = image2;//[UIImage imageNamed:@"back_snow.png"];
//    subIv_background21.image = image1;//[UIImage imageNamed:@"back_desert.png"];
//    subIv_background22.image = image2;//[UIImage imageNamed:@"back_forest2.png"];
    subIv_background11.image = [UIImage imageNamed:@"back_nangoku.png"];//image1;
    subIv_background12.image = [UIImage imageNamed:@"back_snow.png"];
    subIv_background21.image = [UIImage imageNamed:@"back_desert.png"];
    subIv_background22.image = [UIImage imageNamed:@"back_forest2.png"];

//    subIv_oscillate11.image = image1;//[UIImage imageNamed:@"back_nangoku.png"];//image1;
//    subIv_oscillate12.image = image2;//[UIImage imageNamed:@"back_snow.png"];
//    subIv_oscillate21.image = image1;//[UIImage imageNamed:@"back_desert.png"];
//    subIv_oscillate22.image = image2;//[UIImage imageNamed:@"back_forest2.png"];
    subIv_oscillate11.image = image1;//[UIImage imageNamed:@"back_nangoku.png"];//image1;
    subIv_oscillate12.image = image2;//[UIImage imageNamed:@"back_snow.png"];
    subIv_oscillate21.image = image1;//[UIImage imageNamed:@"back_desert.png"];
    subIv_oscillate22.image = image2;//[UIImage imageNamed:@"back_forest2.png"];


    //通常時表示用iv
    [iv_background1 addSubview:subIv_background11];
    [iv_background1 addSubview:subIv_background12];
    [iv_background2 addSubview:subIv_background21];
    [iv_background2 addSubview:subIv_background22];
    
    //振動時表示用iv:複数のビューにaddすると前のviewからremoveされる(subIv_backgroundXXをaddできない)
    [iv_oscillate1 addSubview:subIv_oscillate11];
    [iv_oscillate1 addSubview:subIv_oscillate12];
    [iv_oscillate2 addSubview:subIv_oscillate21];
    [iv_oscillate2 addSubview:subIv_oscillate22];
    
    return self;
}

-(UIImageView *)getIvOscillate1{
    iv_oscillate1.center = ((CALayer *)[iv_background1.layer presentationLayer]).position;
    return iv_oscillate1;
}
-(UIImageView *)getIvOscillate2{
    iv_oscillate2.center = ((CALayer *)[iv_background2.layer presentationLayer]).position;
    return iv_oscillate2;
}
-(void)stopAnimation{
    //静止中、アニメーション中のケースは引数で分ける？
    //静止中の場合
    int x0 = iv_background1.bounds.size.width/2;
    int y0 = originalFrameSize;
    //アニメーション中の場合
//    int x1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.x;
//    int y1 = ((CALayer *)[iv_background1.layer presentationLayer]).position.y;
//    int x2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.x;
//    int y2 = ((CALayer *)[iv_background2.layer presentationLayer]).position.y;
    
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


-(void)pauseAnimations{
    //about1
    CFTimeInterval pausedTime1 = [iv_background1.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    iv_background1.layer.speed = 0.0;
    iv_background1.layer.timeOffset = pausedTime1;
    //abount2
    CFTimeInterval pausedTime2 = [iv_background2.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    iv_background2.layer.speed = 0.0f;
    iv_background2.layer.timeOffset = pausedTime2;

}


-(void)resumeAnimations{
    //about1
    CFTimeInterval pausedTime1 = [iv_background1.layer timeOffset];
    iv_background1.layer.speed = nowSpeed;
    iv_background1.layer.timeOffset = 0.0f;
    iv_background1.layer.beginTime = 0.0f;
    CFTimeInterval timeSincePause1 = [iv_background1.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime1;
    iv_background1.layer.beginTime = timeSincePause1;
    //about2
    CFTimeInterval pausedTime2 = [iv_background2.layer timeOffset];
    iv_background2.layer.speed = nowSpeed;
    iv_background2.layer.timeOffset = 0.0f;
    iv_background2.layer.beginTime = 0.0f;
    CFTimeInterval timeSincePause2 = [iv_background2.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime2;
    iv_background2.layer.beginTime = timeSincePause2;
}


-(void)oscillateEffect:(int)count{
    
//    iv_oscillate1.center = ((CALayer *)[iv_background1.layer presentationLayer]).position;
//    iv_oscillate2.center = ((CALayer *)[iv_background2.layer presentationLayer]).position;
//理想的にはiv_oscillateXはiv_backgroundX上にのっけて、コントローラー側でself.view addSubviewしないようにする
//    if(iv_oscillate1.superview == nil ||
//       iv_oscillate2.superview == nil){
////        [iv_background1 addSubview:iv_oscillate1];
////        [iv_background2 addSubview:iv_oscillate2];
////        iv_oscillate1.center = CGPointMake(iv_background1.bounds.size.width/2,
////                                           iv_background1.bounds.size.height/2);
////        iv_oscillate2.center = CGPointMake(iv_background2.bounds.size.width/2,
////                                           iv_background2.bounds.size.height/2);
//
//        [iv_background1.superview addSubview:iv_oscillate1];
//        [iv_background2.superview addSubview:iv_oscillate2];
//        [iv_background1.superview bringSubviewToFront:iv_oscillate1];
//        [iv_background2.superview bringSubviewToFront:iv_oscillate2];
//    }else{
//        NSLog(@"iv_ocsillate1 is already added on %@", iv_oscillate1.superview);
//        NSLog(@"iv_ocsillate2 is already added on %@", iv_oscillate2.superview);
//    }

//    CGPoint kStartPos1 = iv_oscillate1.center;
    
    
    [self oscillate1:count];
    [self oscillate2:count];
}

-(void)oscillate1:(int)count{

    CGPoint kStartPos1 = ((CALayer *)[iv_background1.layer presentationLayer]).position;
    
    CGPoint kEndPos1 = CGPointMake(kStartPos1.x + ((count%2==0)?-oscillateWidth:+oscillateWidth),
                                   kStartPos1.y);
    
    //about1
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{
        CAAnimation *animationForKeyFrame = [iv_oscillate1.layer animationForKey:@"position"];
        NSLog(@"value of iv_oscillate1.layer = %@", animationForKeyFrame);
        //        NSLog(@"%d", (int)animationForKeyFrame);
        [iv_oscillate1.layer removeAnimationForKey:@"position"];
        //        [iv_oscillate2.layer removeAnimationForKey:@"position"];
        if(animationForKeyFrame){
            NSLog(@"count =%d", count-1);
            
            if(count > 0){
                NSLog(@"count=%d->recursive", count);
                [self oscillate1:count-1];
            }else{
                [iv_oscillate1 removeFromSuperview];
                //                [iv_oscillate2 removeFromSuperview];
                NSLog(@"finished oscillate at kStartPos1.y=%f", kStartPos1.y);
                //                [self animation1:gSecs start:kStartPos1.y];
                [self resumeAnimations];
            }
        }
    }];
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setValue:@"animation1" forKey:@"id"];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.duration = 0.07f;
        animation.fromValue = [NSValue valueWithCGPoint:kStartPos1];
        animation.toValue = [NSValue valueWithCGPoint:kEndPos1];
        [iv_oscillate1.layer addAnimation:animation forKey:@"position"];
        //        [iv_oscillate2.layer addAnimation:animation forKey:@"position"];
        
    }
    [CATransaction commit];
    
}
-(void)oscillate2:(int)count{
    CGPoint kStartPos2 = ((CALayer *)[iv_background2.layer presentationLayer]).position;
    
    CGPoint kEndPos2 = CGPointMake(kStartPos2.x + ((count%2==0)?-oscillateWidth:+oscillateWidth),
                                   kStartPos2.y);
//    CGPoint kStartPos2 = ((CALayer *)[iv_background2.layer presentationLayer]).position;
//    CGPoint kEndPos2 = CGPointMake(kStartPos2.x + ((count%2==0)?-50:+50),
//                                   kStartPos2.y);
    
    
    //about2
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{
        CAAnimation *animationForKeyFrame = [iv_oscillate2.layer animationForKey:@"position"];
        NSLog(@"value of iv_oscillate2.layer = %@", animationForKeyFrame);
        //        NSLog(@"%d", (int)animationForKeyFrame);
        [iv_oscillate2.layer removeAnimationForKey:@"position"];
//        [iv_oscillate2.layer removeAnimationForKey:@"position"];
        if(animationForKeyFrame){
            NSLog(@"count =%d", count);
            
            if(count > 0){
                NSLog(@"count=%d->recursive", count);
                [self oscillate2:count-1];
            }else{
                [iv_oscillate2 removeFromSuperview];
                NSLog(@"finished oscillate at kStartPos2.y=%f", kStartPos2.y);
//                [self resumeAnimations];//not execute here , it is only for 1
            }
        }
    }];
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setValue:@"animation2" forKey:@"id"];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.duration = 0.07f;
        animation.fromValue = [NSValue valueWithCGPoint:kStartPos2];
        animation.toValue = [NSValue valueWithCGPoint:kEndPos2];
        [iv_oscillate2.layer addAnimation:animation forKey:@"position"];
        
    }
    [CATransaction commit];
}
-(void)animation1:(int)y0{
    
    //一定速度に
    //cabasicanimationで中間地点を指定しない
    //recursiveに
    NSLog(@"animation1");
    CGPoint kStartPos =CGPointMake(iv_background1.bounds.size.width/2,
                                   y0);//-2 * originalFrameSize);
    //iv_background1.center;//((CALayer *)[iv_background1.layer presentationLayer]).position;//
    CGPoint kEndPos = CGPointMake(iv_background1.bounds.size.width/2,
                                  2 * originalFrameSize);
    
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{//終了処理
        CAAnimation* animationKeyFrame = [iv_background1.layer animationForKey:@"position"];
        if(animationKeyFrame){
            NSLog(@"recursive1 layer=%f,iv=%f", ((CALayer *)[iv_background1.layer presentationLayer]).position.y,
                  iv_background1.center.y);
            
            /*
             *以下removeによりoscillateされたときに初期化されてしまう？
             */
            [iv_background1.layer removeAnimationForKey:@"position"];
            //speedup
            [self setSpeed:nowSpeed+0.15f];
            //recurrent構造にせずにrepeatCount=HUGE_VALにすれば繰り返し実行できるが、最初の位置からの移動で場合分けが必要になる
            
            NSLog(@"recursive1 layer=%f,iv1=%f, lay2=%f", ((CALayer *)[iv_background1.layer presentationLayer]).position.y,
                  iv_background1.center.y,
                  ((CALayer *)[iv_background2.layer presentationLayer]).position.y);
//            [self animation1:-2*originalFrameSize];
            //微妙に呼び出し時間がかかって再起呼出しした後の表示場所が2の上端とズレるのでリアルタイムに2の場所を把握して逆算して表示
            [self animation1:((CALayer *)[iv_background2.layer presentationLayer]).position.y - 2 * originalFrameSize];
        }else{
            //ここには制御が移らない
//            NSLog(@"強制終了");
//            [iv_background1.layer removeAnimationForKey:@"position"];
//            NSLog(@"recursive1 layer=%f,iv=%f", ((CALayer *)[iv_background1.layer presentationLayer]).position.y,
//                  iv_background1.center.y);
        }
        
    }];
    
    {
        
//        CAKeyframeAnimation *animation;
//        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.duration = (float)gSecs * (2*originalFrameSize-y0)/(4*originalFrameSize);
//        animation.repeatCount = HUGE_VAL;
        
        animation.fromValue = [NSValue valueWithCGPoint:kStartPos];
        animation.toValue = [NSValue valueWithCGPoint:kEndPos];
        
        // レイヤーにアニメーションを追加
        [iv_background1.layer addAnimation:animation forKey:@"position"];
        
    }
    [CATransaction commit];
    
}

-(void)animation2:(int)y2{
    NSLog(@"animation2 start");
    CGPoint kStartPos2 = CGPointMake(iv_background2.center.x,
                                     y2);//-2 * originalFrameSize);
    CGPoint kEndPos2 = CGPointMake(iv_background2.center.x,
                                   2 * originalFrameSize);
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setCompletionBlock:^{
        CAAnimation *animationKeyFrame = [iv_background2.layer animationForKey:@"position"];
        if(animationKeyFrame){
            NSLog(@"finisheded 2 recursive animation");
            [iv_background2.layer removeAnimationForKey:@"position"];
            //recurrent構造にせずにrepeatCount=HUGE_VALにすれば無限ループ
            [self animation2:-2 * originalFrameSize];
        }
    }];
    
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
//        animation.duration = secs;
        animation.duration = (float)gSecs * (2 * originalFrameSize - y2)/(4*originalFrameSize);
//        animation.repeatCount = HUGE_VAL;
        animation.fromValue = [NSValue valueWithCGPoint:kStartPos2];
        animation.toValue = [NSValue valueWithCGPoint:kEndPos2];
        [iv_background2.layer addAnimation:animation
                                    forKey:@"position"];
    }
    [CATransaction commit];
    
    
}


-(void)startAnimation{
    NSLog(@"start animation method call");
    //1*original->2*original
    //moving-distance=1*original : duration=routine/4
    [self animation1:iv_background1.center.y];
    
    //-1*original->2*original
    //moving-distance=3*original : duration=routine*3/4
    [self animation2:iv_background2.center.y];
//    CGPoint kStartPos1 = iv_background1.center;
//    CGPoint kEndPos1 = CGPointMake(iv_background1.center.x,
//                                   2 * originalFrameSize);
//    [CATransaction begin];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    [CATransaction setCompletionBlock:^{
//        CAAnimation *animationKeyFrame = [iv_background1.layer animationForKey:@"position"];
//        if(animationKeyFrame){
//            NSLog(@"finish first animation then calling sequential animation method");
//            [iv_background1.layer removeAnimationForKey:@"position"];
//            [self animation1:(float)secs start:-2*originalFrameSize];
//        }
//    }];
//    
//    {
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//        animation.fillMode = kCAFillModeForwards;
//        animation.removedOnCompletion = NO;
//        animation.duration = (float)secs/4;
//        animation.fromValue = [NSValue valueWithCGPoint:kStartPos1];
//        animation.toValue = [NSValue valueWithCGPoint:kEndPos1];
//        [iv_background1.layer addAnimation:animation
//                                    forKey:@"position"];
//    }
//    [CATransaction commit];
    
    

//    CGPoint kStartPos2 = iv_background2.center;
//    CGPoint kEndPos2 = CGPointMake(iv_background2.center.x,
//                                   2 * originalFrameSize);
//    [CATransaction begin];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    [CATransaction setCompletionBlock:^{
//        CAAnimation *animationKeyFrame = [iv_background2.layer animationForKey:@"position"];
//        if(animationKeyFrame){
//            NSLog(@"finish first animation then calling sequential animation method");
//            [iv_background2.layer removeAnimationForKey:@"position"];
//            [self animation2:secs start:-2 * originalFrameSize];
//        }
//    }];
//    
//    {
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//        animation.fillMode = kCAFillModeForwards;
//        animation.removedOnCompletion = NO;
//        animation.duration = (float)secs*3/4;
//        animation.fromValue = [NSValue valueWithCGPoint:kStartPos2];
//        animation.toValue = [NSValue valueWithCGPoint:kEndPos2];
//        [iv_background2.layer addAnimation:animation
//                                    forKey:@"position"];
//    }
    
//    int y1 = iv_background1.center.y;//((CALayer *)[iv_background1.layer presentationLayer]).position.y;
//    int x1 = iv_background1.center.x;//((CALayer *)[iv_background1.layer presentationLayer]).position.x;
//    int y2 = iv_background2.center.y;//((CALayer *)[iv_background2.layer presentationLayer]).position.y;
//    int x2 = iv_background2.center.x;//((CALayer *)[iv_background2.layer presentationLayer]).position.x;
//    //    NSLog(@"x1=%d, x2=%d, y1=%d, y2=%d, originalFsize=%d", x1, x2, y1, y2, originalFrameSize);
//    NSLog(@"start2 : xC1=%f, xC2=%f, yC1=%f, yC2=%f, originalFrameSize=%d, secs=%f",
//          iv_background1.bounds.size.width/2,
//          iv_background2.bounds.size.width/2,
//          iv_background1.center.y,
//          iv_background2.center.y,
//          originalFrameSize, secs);
//    iv_background1.center = CGPointMake(x1, y1);
//    iv_background2.center = CGPointMake(x2, y2);
//    
//    [UIView animateWithDuration:secs
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveLinear//constant-speed
//                     animations:^{
//                         iv_background1.center =
//                         CGPointMake(x1, y1 + originalFrameSize);
//                         
//                         iv_background2.center =
//                         CGPointMake(x2, y2 + originalFrameSize);
//                     }
//                     completion:^(BOOL finished){
//                         NSLog(@"background animation finished=%@, secs=%f", finished?@"true":@"false", secs);
//                         //初期化
//                         if(finished){
//                             NSLog(@"finished : xC1=%f, xC2=%f, yC1=%f, yC2=%f, originalFrameSize=%d",
//                                   iv_background1.bounds.size.width/2,
//                                   iv_background2.bounds.size.width/2,
//                                   iv_background1.center.y,
//                                   iv_background2.center.y,
//                                   originalFrameSize);
//                             
//                             if(iv_background1.center.y > originalFrameSize){
//                                 iv_background1.center =
//                                 CGPointMake(iv_background1.bounds.size.width/2,
//                                             -originalFrameSize/2);
//                             }
//                             if(iv_background2.center.y > originalFrameSize){
//                                 iv_background2.center =
//                                 CGPointMake(iv_background2.bounds.size.width/2,
//                                             -originalFrameSize/2);
//                             }
//                             
//                             NSLog(@"recursive startAnimation");
//                             [self startAnimation:secs];
//                             //                             [self startAnimation:1.0f];
//                             
//                         }
//                     }];
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
    NSLog(@"get imageview 1");
    return iv_background1;
}
-(UIImageView *)getImageView2{
    return iv_background2;
}


-(void)setSpeed:(float)speed{
    if(iv_background1.layer.speed > 0){
    nowSpeed = speed;
    iv_background1.layer.timeOffset = [iv_background1.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    iv_background1.layer.beginTime = CACurrentMediaTime();
    iv_background1.layer.speed=nowSpeed;
    iv_background2.layer.timeOffset = [iv_background2.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    iv_background2.layer.beginTime = CACurrentMediaTime();
    iv_background2.layer.speed=nowSpeed;
    }
}

@end
