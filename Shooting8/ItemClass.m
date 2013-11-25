//
//  ItemClass.m
//  Shooting4
//
//  Created by 遠藤 豪 on 13/10/02.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ItemClass.h"
#import "UIView+Animation.h"
#import "KiraParticleView.h"

@implementation ItemClass

@synthesize type;
NSArray *arrayUIImageKira;//UIImage-array
CGRect rectKira;
int numCell;


-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h{
    type = arc4random() % 10;//[NSNumber numberWithInt:arc4random()];
    if(type <= 2){
        type = ItemTypeYellowGold;
    }else{
        type = arc4random() % 16;
    }
    
    
    
    //polymophysm
    return [self init:type x_init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h];
}
-(id) init:(ItemType)_type x_init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h{
    lifetime_count = 0;
    isMagnetMode = false;
    y_loc = y_init;
    x_loc = x_init;
    width = w;
    height = h;
    isAlive = true;
    arrayViewKira = [[NSMutableArray alloc]init];
    numCell = 10;
    arrayUIImageKira = [[NSArray alloc] initWithObjects:
       [UIImage imageNamed:@"img03.png"],
       [UIImage imageNamed:@"img04.png"],
       [UIImage imageNamed:@"img05.png"],
       [UIImage imageNamed:@"img06.png"],
       [UIImage imageNamed:@"img07.png"],
       [UIImage imageNamed:@"img08.png"],
       [UIImage imageNamed:@"img09.png"],
       [UIImage imageNamed:@"img10.png"],
       [UIImage imageNamed:@"img11.png"],
       nil];
    //アイテム生成時のパーティクルの初期化
    occurredParticle = [[KiraParticleView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 10, 10)];
    [occurredParticle setLifeSpan:10];
    [occurredParticle setParticleType:ParticleTypeOccurred];
    
    //アイテム動線上にランダムに発生するパーティクル格納配列：doNext内で要素生成＆格納
//    kiraMovingArray = [[NSMutableArray alloc]init];
    
//    http://stackoverflow.com/questions/9395914/switch-with-typedef-enum-type-from-string
    type = _type;
    switch(type){
        case ItemTypeWeapon0:{//青：攻撃力上昇 at int 0
//            rect = CGRectMake(x_loc, y_loc, w, h);
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"weapon_bomb.png"];//未
            break;
        }
        case ItemTypeWeapon1:{//1
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"weapon_diffuse.png"];//済
            
            break;
        }
        case ItemTypeWeapon2:{
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"weapon_laser.png"];//未
            break;
        }
        case ItemTypeDeffense0:{
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"defense_barrier.png"];//
            
            break;
        }
        case ItemTypeDeffense1:{
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"defense_shield.png"];
            
            break;
        }
        case ItemTypeMagnet:{//5
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"tool_magnet.png"];
            break;
        }
        case ItemTypeBomb://画面内敵全滅
        {
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"tool_bomb.png"];
            break;
        }
        case ItemTypeHeal://赤：回復
        {
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"tool_heal.png"];
            break;
        }
        case ItemTypeYellowGold:
        {
            rect = CGRectMake(x_loc, y_loc, (float)w*2/3, (float)h*2/3);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin_yellow.png"];
            break;
        }
        case ItemTypeGreenGold:
        {
            rect = CGRectMake(x_loc, y_loc, (float)w*2/3, (float)h*2/3);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin_green.png"];
            break;
        }
        case ItemTypeBlueGold:
        {
            rect = CGRectMake(x_loc, y_loc, (float)w*2/3, (float)h*2/3);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin_blue.png"];
            break;
        }
        case ItemTypePurpleGold:
        {
            rect = CGRectMake(x_loc, y_loc, (float)w*2/3, (float)h*2/3);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin_purple.png"];
            break;
        }
        case ItemTypeRedGold:
        {
            rect = CGRectMake(x_loc, y_loc, (float)w*2/3, (float)h*2/3);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin_red.png"];
            break;
        }
        case ItemTypeBig:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"tool_big.png"];
            break;
        }
        case ItemTypeSmall:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"tool_small_cookie.png"];
            break;
        }
        case ItemTypeTransparency:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"tool_transparancy.png"];
            break;
        }
    }
    //中心座標にする
    iv.center = CGPointMake(x_loc, y_loc);
//    [iv moveBoundDuration:0 option:0];
    
//    
//    
//    CGPoint kStartPos = iv.center;//((CALayer *)[iv.layer presentationLayer]).position;
//    CGPoint kEndPos = CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
//                                  iv.superview.bounds.size.height + height);//480);//
//    [CATransaction begin];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    [CATransaction setCompletionBlock:^{//終了処理
//        CAAnimation* animationKeyFrame = [iv.layer animationForKey:@"position"];
//        if(animationKeyFrame){
//            //途中で終わらずにアニメーションが全て完了して
////            [self die];
////            NSLog(@"animation key frame already exit & die");
//        }else{
//            //途中で何らかの理由で遮られた場合
////            NSLog(@"animation key frame not exit");
//        }
//        
//    }];
//    
//    {
//        
//        // CAKeyframeAnimationオブジェクトを生成
//        CAKeyframeAnimation *animation;
//        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        animation.fillMode = kCAFillModeForwards;
//        animation.removedOnCompletion = NO;
//        animation.duration = 1.0;
//        
//        // 放物線のパスを生成
//        //    CGFloat jumpHeight = kStartPos.y * 0.2;
//        CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
//        CGMutablePathRef curvedPath = CGPathCreateMutable();
//        CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
//        CGPathAddCurveToPoint(curvedPath, NULL,
//                              peakPos.x, peakPos.y,
//                              (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
//                              kEndPos.x, kEndPos.y);
//        
//        // パスをCAKeyframeAnimationオブジェクトにセット
//        animation.path = curvedPath;
//        
//        // パスを解放
//        CGPathRelease(curvedPath);
//        
//        // レイヤーにアニメーションを追加
//        [iv.layer addAnimation:animation forKey:@"position"];
//        
//    }
//    [CATransaction commit];

    
    
    
//methodology1
//    [CATransaction begin];//up
////    [CATransaction setAnimationDuration:0.5f];
//    [CATransaction setCompletionBlock:^{//up終了処理
//        CAAnimation* animationUp = [iv.layer animationForKey:@"up"];
//        
////        NSLog(@"item : x = %f, y = %f",
////              ((CALayer *)[iv.layer presentationLayer]).position.x,
////              ((CALayer *)[iv.layer presentationLayer]).position.y);
//        if (animationUp) {//終了時処理
//            // -animationDidStop:finished: の finished=YES に相当
//            
////            [iv.layer removeAnimationForKey:@"up"];   // 後始末：removeすると"up"開始位置に戻ってしまう
//            
//            
//            
//            [CATransaction begin];//down
//            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//            [CATransaction setCompletionBlock:^{//down終了処理
//                CAAnimation* animationDown = [iv.layer animationForKey:@"down"];
//                
//                if(animationDown){
//                    NSLog(@"die at center:%f, layer.position:%f, y_loc:%d, %d",//【緊急！】なぜかup終了後の位置を取得している=y_locも同様！＝＞アイテムが取得できない！！
//                          iv.center.y,
//                          ((CALayer *)iv.layer.presentationLayer).position.y,y_loc,
//                          isAlive);
////                       // 後始末
////                    [self die];//下まで行ったら処理
//                    NSLog(@"die at center:%f, layer.position:%f, y_loc:%d, %d", iv.center.y,
//                          ((CALayer *)iv.layer.presentationLayer).position.y,y_loc,
//                          isAlive);
//                    
//                }else{
//                    //途中で別のアニメーション等の割り込み等によってdownアニメが終了しても、別のアニメ終了後に再度downアニメが開始されるように残しておく？
////                    [iv.layer removeAnimationForKey:@"down"];   // 後始末
//                }
//                
//                
//                
//            }];
//            
//            {
//                
//                CABasicAnimation *animDown = [CABasicAnimation animationWithKeyPath:@"position"];
//                [animDown setDuration:1.0f];
////                animDown.fromValue = [NSValue valueWithCGPoint:((CALayer *)[iv.layer presentationLayer]).position];
//                animDown.toValue = [NSValue valueWithCGPoint:CGPointMake(((CALayer *)[iv.layer presentationLayer]).position.x,
//                                                                         iv.superview.bounds.size.height)];//myview.superview.bounds.size.height)];
//                // completion処理用に、アニメーションが終了しても登録を残しておく
//                animDown.removedOnCompletion = NO;
//                animDown.fillMode = kCAFillModeForwards;
//                
//                [iv.layer addAnimation:animDown forKey:@"down"];//uiviewから生成したlayerをanimation
//            }
//            [CATransaction commit];
//            
//        }
//        else {
//            // -animationDidStop:finished: の finished=NO に相当
////            [iv.layer removeAnimationForKey:@"up"];   // 後始末
//        }
//        
//    }];
//    
//    
////    [CATransaction setAnimationDuration:0.5f];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    
//    {
//        CABasicAnimation *animUp = [CABasicAnimation animationWithKeyPath:@"position"];
//        [animUp setDuration:0.4f];
//        //最初はアニメーションが始まっていないので中心位置はUIView.centerで取得
////        animUp.fromValue = [NSValue valueWithCGPoint:iv.center];//((CALayer *)[iv.layer presentationLayer]).position];
//        animUp.toValue = [NSValue valueWithCGPoint:CGPointMake(iv.center.x,//((CALayer *)[iv.layer presentationLayer]).position.x,
//                                                               iv.center.y * 0.2)];//myview.superview.bounds.size.height)];
//        // completion処理用に、アニメーションが終了しても登録を残しておく
//        animUp.removedOnCompletion = NO;
//        animUp.fillMode = kCAFillModeForwards;
//        [iv.layer addAnimation:animUp forKey:@"up"];//uiviewから生成したlayerをanimation
//        
//    }
//    [CATransaction commit];

//methodology2
//    [UIView animateWithDuration:0.4f
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseOut//はじめ早く、段々ゆっくりに停止
//                     animations:^{
//                         iv.center = CGPointMake(iv.center.x,
//                                                 iv.center.y * 0.2f);
//                     }
//                     completion:^(BOOL finished1){
//                         
//                         if(finished1){
////                             [UIView moveDownDuration:1.5f
////                                             option:option];
//                             float destination_y =iv.superview.bounds.size.height + height;
//                             //    float _secs = destination_y * 0.002f;//1px = 0.002sec(2msec) => 500px = 1sec:少し速い
//                             
//                             
//                             //GameClassViewCont;isMagnetModeでアイテムを上記アニメーションの途中からでも自動的に呼び出せるようにする方法はCATransaction(以下)
//                             [CATransaction begin];
//                             [CATransaction setAnimationDuration:1.5f];
//                             [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//                             [CATransaction setCompletionBlock:^{
//                                 NSLog(@"die");
//                                 [self die];
//                             }];
//                             iv.layer.position = CGPointMake(iv.center.x,
//                                                             destination_y);
//                             [CATransaction commit];
//                             
//                             
//                             //以下のようにしてしまうとマグネットフラグ時のスムーズなアニメーションの切り替えが出来ない
////                             [UIView animateWithDuration:1.5f
////                                                   delay:0.0f
////                                                 options:UIViewAnimationOptionCurveEaseIn//ゆっくりから早く(突然停止)
////                                              animations:^{
////                                                  iv.center = CGPointMake(iv.center.x,
////                                                                            destination_y);
////                                              }
////                                              completion:^(BOOL finished2){
////                                                  
////                                                  if(finished2){
////                                                      //                             NSLog(@"complete down from down2 Method");
////                                                      [self die];
////                                                  }
////                                              }];
//                         }
//                     }];
    
    return self;
}
-(id) init{
//    NSLog(@"call enemy class initialization");
    return [self init:0 y_init:0 width:10 height:10];
}
-(ItemType)getType{
    return type;
    
}



-(Boolean) getIsAlive{
    return isAlive;
}

-(Boolean) getIsMagnetMode{
    return isMagnetMode;
}

-(void) setIsMagnetMode:(Boolean)_isSweepMode{
    isMagnetMode = _isSweepMode;
}

/**
 *アイテム移動中にパーティクルが発生したらtrueを返す
 */
-(Boolean)doNext{
    if(lifetime_count == 0){
        
        
        CGPoint kStartPos = iv.center;//((CALayer *)[iv.layer presentationLayer]).position;
        CGPoint kEndPos = CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
                                      iv.superview.bounds.size.height + height);//480);//
        [CATransaction begin];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [CATransaction setCompletionBlock:^{//終了処理
            CAAnimation* animationKeyFrame = [iv.layer animationForKey:@"position"];
            if(animationKeyFrame){
                //途中で終わらずにアニメーションが全て完了して
                //            [self die];
                //            NSLog(@"animation key frame already exit & die");
            }else{
                //途中で何らかの理由で遮られた場合
                //            NSLog(@"animation key frame not exit");
            }
            
        }];
        
        {
            
            // CAKeyframeAnimationオブジェクトを生成
            CAKeyframeAnimation *animation;
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.duration = 1.0;
            
            // 放物線のパスを生成
            //    CGFloat jumpHeight = kStartPos.y * 0.2;
            CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
            CGPathAddCurveToPoint(curvedPath, NULL,
                                  peakPos.x, peakPos.y,
                                  (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                                  kEndPos.x, kEndPos.y);
            
            // パスをCAKeyframeAnimationオブジェクトにセット
            animation.path = curvedPath;
            
            // パスを解放
            CGPathRelease(curvedPath);
            
            // レイヤーにアニメーションを追加
            [iv.layer addAnimation:animation forKey:@"position"];
            
        }
        [CATransaction commit];
    }
    
//    NSLog(@"donext at item class");
    Boolean isOccurringParticle = false;
    
    //ivはmoveBoundDurationによって自動アニメーション：各時刻の値をパラメータに格納
    CALayer *mLayer = [iv.layer presentationLayer];
    x_loc = mLayer.position.x;//中心座標
    y_loc = mLayer.position.y;//中心座標
    
    if(y_loc >= iv.superview.bounds.size.height + height){
        [self die];
    }
//    NSLog(@"process : %d , %d",
//          x_loc, y_loc);
    
    //動線上に新規キラキラ発生
    if(lifetime_count % 50 ==0){//generate every count
//    if(true){
//        movingParticle = [[KiraParticleView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 10, 10)
//                                                   particleType:ParticleTypeMoving];
////        [movingParticle setParticleType:ParticleTypeMoving];
//        [movingParticle setIsEmitting:30];
//        [movingParticle setAlpha:1.0f];
//        
//        //up(down) , alpha = 0.0f, then remove.
//        [UIView animateWithDuration:0.49f
//                         animations:^{
//                             [movingParticle setAlpha:0.0f];//徐々に薄く
//                         }
//                         completion:^(BOOL finished){
//                             [movingParticle setIsEmitting:NO];
//                             [movingParticle removeFromSuperview];
//                         }];
//        [kiraMovingArray insertObject:movingParticle atIndex:0];//FIFO
        [self drawKira];
        isOccurringParticle = true;
    
    }
    
    
    lifetime_count ++;
    return isOccurringParticle;
    
    
}


-(void) die{
    //アイテム消滅時(プレイヤーによる取得時)のパーティクルの初期化
//    killedParticle = [[KiraParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, 40, 40)
//                                                                  particleType:ParticleTypeKilled];
////    [killedParticle setIsEmitting:1];
//    [UIView animateWithDuration:0.5f
//                     animations:^{
//                         [killedParticle setAlpha:3.0f];//最初は濃く
//                     }
//                     completion:^(BOOL finished){
//                         
//                         [UIView animateWithDuration:0.5f//次に徐々に薄く小さく
//                                          animations:^{
//                                              [killedParticle setAlpha:0.0f];
//                                          }
//                                          completion:^(BOOL finished){
//                                              //終了時処理
//                                              [killedParticle setIsEmitting:NO];
//                                              [killedParticle removeFromSuperview];
//
//                                          }];
//                         
//                     }];
    
//    NSLog(@"isMagnetMode = %d", isMagnetMode);
    
    
    isAlive = false;
}
-(void) setLocation:(CGPoint)loc{
    x_loc = (int)loc.x;
    y_loc = (int)loc.y;
}

-(void)setX:(int)x{
    x_loc = x;
}
-(void)setY:(int)y{
    y_loc = y;
}

-(CGPoint) getLocation{
    return CGPointMake((float)x_loc, (float)y_loc);
}

-(int) getX{
    return x_loc;
}

-(int) getY{
    return y_loc;
}

-(UIImageView *)getImageView{
    //    [iv removeFromSuperview];
    //ここでivに代入するとself.viewに張り付いているivとは別オブジェクトが新規に生成されてしまう。
    //=>だからdoNextで移動距離を計算し、そこでivも作ってしまうことに。
    //    rect = CGRectMake(x_loc, y_loc, mySize, mySize);
    //    iv = [[UIImageView alloc]initWithFrame:rect];
    //    iv.image = [UIImage imageNamed:@"enemy.png"];
    return iv;
}

//-(KiraParticleView *)getMovingParticle:(int)kiraNo{//アイテムが動いている時のパーティクル
////    return movingParticle;
//    if(kiraNo < [kiraMovingArray count]){
//        NSLog(@"output : kira array %@", [kiraMovingArray objectAtIndex:kiraNo]);
//        return [kiraMovingArray objectAtIndex:kiraNo];
//    }
//    return nil;
//}

-(KiraParticleView *)getOccurredParticle{//アイテム発生時のパーティクル
    
    return occurredParticle;
}

-(KiraParticleView *)getKilledParticle{//アイテムが消滅した時のパーティクル
    
    return killedParticle;
}

/*
 *動線上に表示される疑似パーティクル(実際にはiv中心から上部へ向かって表示)
 */
-(void)drawKira{
    countKira = 0;
    for(int i = 0; i < numCell;i++){
        //回復時アニメーション->frame:主人公の左上起点基準
        //        int y = - (arc4random() % originalSize);
        //        NSLog(@"y = %d", y);
        rectKira= CGRectMake(0,//- (arc4random() % originalSize),//左端
                             0,//- (arc4random() % originalSize),//上端
                             arc4random() % width, arc4random() % width);
        ivKira = [[UIImageView alloc] initWithFrame:rectKira];
        ivKira.center = CGPointMake(width/4 + (arc4random() % (width/2)),//中心付近から
                                          arc4random() % (width/2));//上端付近から(降下)
        //        ivHealEffect.center = CGPointMake(0, 0);//test;zero-start
        ivKira.animationImages = arrayUIImageKira;
        ivKira.animationRepeatCount = 0;
        ivKira.alpha = MIN(exp(((float)(arc4random() % 100))*4.0f / 100.0f - 1),1);//0-1の指数関数(１の確率が４分の３)
        ivKira.animationDuration = 1.0f; // アニメーション全体で1秒（＝各画像描画間隔は「枚数」分の１秒）
        [ivKira startAnimating]; // アニメーション開始!!(アイテム取得時に実行)
        
        //上記で設定したUIImageViewを配列格納
        [arrayViewKira addObject:ivKira];
        
        //格納されたUIImageViewを描画
        [iv addSubview:[arrayViewKira objectAtIndex:i]];
    }
    
    /*
     *同時に全ての配列に格納されたセルを降らせる
     */
    //    NSLog(@"healeffect repeat");
    int x0, y0, moveX, moveY;
    for(int i = 0; i < [arrayViewKira count];i++){
        x0 = ((UIImageView*)[arrayViewKira objectAtIndex:i]).center.x;
        y0 = ((UIImageView*)[arrayViewKira objectAtIndex:i]).center.y;
        moveX = arc4random() % width/2 - width/2;//変化量は全体の±1/4
        //移動距離には熱関数を使い、かつy0が小さい程、移動を大きくする(温度係数を2にする):２分の１の確率でwidth移動
        moveY = width*2 * MIN(exp(((float)(arc4random() % 100))*2.0f / 100.0f - 1), 1);
        
        //test:move
        //        moveX = mySize/2;
        //        moveY = mySize/2;
        [UIView animateWithDuration:1.4f * MIN(exp(((float)(arc4random()%10))*4.0f/10.0f-1), 1.0f)//0.4f
                              delay:0//0.2f*exp((float)(arc4random()%10)/10.0f-1)//((float)(arc4random() % 10) /10.0f)//max0.1
         //                            options:UIViewAnimationOptionCurveLinear
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             ((UIImageView*)[arrayViewKira objectAtIndex:i]).center = CGPointMake(x0 + moveX, y0 - moveY);//down
                             //                             ((UIImageView*)[healEffectArray objectAtIndex:i]).center = CGPointMake(0,  0);//down
                             
                             ((UIImageView*)[arrayViewKira objectAtIndex:i]).alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             if(finished){
                                 countKira++;
//                                 NSLog(@"heacomplete = %d", healCompleteCount);
                                 [[arrayViewKira objectAtIndex:i] removeFromSuperview];
                                 //                                 [healEffectArray removeObjectAtIndex:i];
                                 if(countKira == [arrayViewKira count]){//最後完了後
                                     [arrayViewKira removeAllObjects];
                                 }
                             }
                         }];
    }
    
}

@end
