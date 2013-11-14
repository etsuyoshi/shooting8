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
    
    isMagnetMode = false;
    y_loc = y_init;
    x_loc = x_init;
    width = w;
    height = h;
    isAlive = true;
    
    //アイテム生成時のパーティクルの初期化
    occurredParticle = [[KiraParticleView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 10, 10)];
    [occurredParticle setLifeSpan:10];
    [occurredParticle setParticleType:ParticleTypeOccurred];
    
    //アイテム動線上にランダムに発生するパーティクル格納配列：doNext内で要素生成＆格納
//    kiraMovingArray = [[NSMutableArray alloc]init];
    
//    http://stackoverflow.com/questions/9395914/switch-with-typedef-enum-type-from-string
    type = _type;
    switch(type){
        case ItemTypeWeapon0:{//青：攻撃力上昇
//            rect = CGRectMake(x_loc, y_loc, w, h);
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"weapon_bomb.png"];
            break;
        }
        case ItemTypeWeapon1:{
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"weapon_diffuse.png"];
            
            break;
        }
        case ItemTypeWeapon2:{
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"weapon_laser.png"];
            break;
        }
        case ItemTypeDeffense0:{
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"defense_barrier.png"];
            
            break;
        }
        case ItemTypeDeffense1:{
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"defense_shield.png"];
            
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
        case ItemTypeMagnet:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"tool_magnet.png"];
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
            iv.image = [UIImage imageNamed:@"tool_transparency.png"];
            break;
        }
    }
    //中心座標にする
    iv.center = CGPointMake(x_loc, y_loc);
//    [iv moveBoundDuration:0 option:0];
    
    
    
    [CATransaction begin];//up
//    [CATransaction setAnimationDuration:0.5f];
    [CATransaction setCompletionBlock:^{//up終了処理
        CAAnimation* animationUp = [iv.layer animationForKey:@"up"];
        
//        NSLog(@"item : x = %f, y = %f",
//              ((CALayer *)[iv.layer presentationLayer]).position.x,
//              ((CALayer *)[iv.layer presentationLayer]).position.y);
        if (animationUp) {//終了時処理
            // -animationDidStop:finished: の finished=YES に相当
            
//            [iv.layer removeAnimationForKey:@"up"];   // 後始末：removeすると"up"開始位置に戻ってしまう
            
            
            
            [CATransaction begin];//down
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [CATransaction setCompletionBlock:^{//down終了処理
                CAAnimation* animationDown = [iv.layer animationForKey:@"down"];
                
                if(animationDown){
                    NSLog(@"die at center:%f, layer.position:%f, y_loc:%d, %d",//【緊急！】なぜかup終了後の位置を取得している=y_locも同様！＝＞アイテムが取得できない！！
                          iv.center.y,
                          ((CALayer *)iv.layer.presentationLayer).position.y,y_loc,
                          isAlive);
//                    [iv.layer removeAnimationForKey:@"down"];   // 後始末
//                    [self die];//下まで行ったら処理
                    NSLog(@"die at center:%f, layer.position:%f, y_loc:%d, %d", iv.center.y,
                          ((CALayer *)iv.layer.presentationLayer).position.y,y_loc,
                          isAlive);
                    
                }else{
                    //途中で別のアニメーション等の割り込み等によってdownアニメが終了しても、別のアニメ終了後に再度downアニメが開始されるように残しておく？
//                    [iv.layer removeAnimationForKey:@"down"];   // 後始末
                }
                
                
                
            }];
            
            {
                
                CABasicAnimation *animDown = [CABasicAnimation animationWithKeyPath:@"position"];
                [animDown setDuration:1.0f];
//                animDown.fromValue = [NSValue valueWithCGPoint:((CALayer *)[iv.layer presentationLayer]).position];
                animDown.toValue = [NSValue valueWithCGPoint:CGPointMake(((CALayer *)[iv.layer presentationLayer]).position.x,
                                                                         iv.superview.bounds.size.height)];//myview.superview.bounds.size.height)];
                // completion処理用に、アニメーションが終了しても登録を残しておく
                animDown.removedOnCompletion = NO;
                animDown.fillMode = kCAFillModeForwards;
                
                [iv.layer addAnimation:animDown forKey:@"down"];//uiviewから生成したlayerをanimation
            }
            [CATransaction commit];
            
        }
        else {
            // -animationDidStop:finished: の finished=NO に相当
//            [iv.layer removeAnimationForKey:@"up"];   // 後始末
        }
        
    }];
    
    
//    [CATransaction setAnimationDuration:0.5f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    {
        CABasicAnimation *animUp = [CABasicAnimation animationWithKeyPath:@"position"];
        [animUp setDuration:0.4f];
        //最初はアニメーションが始まっていないので中心位置はUIView.centerで取得
//        animUp.fromValue = [NSValue valueWithCGPoint:iv.center];//((CALayer *)[iv.layer presentationLayer]).position];
        animUp.toValue = [NSValue valueWithCGPoint:CGPointMake(iv.center.x,//((CALayer *)[iv.layer presentationLayer]).position.x,
                                                               iv.center.y * 0.2)];//myview.superview.bounds.size.height)];
        // completion処理用に、アニメーションが終了しても登録を残しておく
        animUp.removedOnCompletion = NO;
        animUp.fillMode = kCAFillModeForwards;
        [iv.layer addAnimation:animUp forKey:@"up"];//uiviewから生成したlayerをanimation
        
    }
    [CATransaction commit];

    
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
//    NSLog(@"donext at item class");
    Boolean isOccurringParticle = false;
    //移動
//    y_loc += 10;
    
    //引寄せアイテム発動中でなければ
//    iv.center = CGPointMake(x_loc, y_loc);
    
    
    //ivはmoveBoundDurationによって自動アニメーション：各時刻の値をパラメータに格納
    CALayer *mLayer = [iv.layer presentationLayer];
    x_loc = mLayer.position.x;//中心座標
    y_loc = mLayer.position.y;//中心座標
//    NSLog(@"process : %d , %d",
//          x_loc, y_loc);
    
    //動線上に新規キラキラ発生
//    if(arc4random() % 3 ==0){//generate every count
//        movingParticle = [[KiraParticleView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 10, 10)
//                                                   particleType:ParticleTypeMoving];
////        [movingParticle setParticleType:ParticleTypeMoving];
//        [movingParticle setIsEmitting:3];
//
//        
//        
//        [UIView animateWithDuration:1.0f
//                         animations:^{
//                             [movingParticle setAlpha:0.0f];//徐々に薄く
//                         }
//                         completion:^(BOOL finished){
//                             [movingParticle setIsEmitting:NO];
//                             [movingParticle removeFromSuperview];
//                         }];
////        [kiraMovingArray insertObject:movingParticle atIndex:0];//FIFO
//        isOccurringParticle = true;
//    
//    }
    
    return isOccurringParticle;
    
    
}


-(void) die{
    //アイテム消滅時(プレイヤーによる取得時)のパーティクルの初期化
    killedParticle = [[KiraParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, 40, 40)
                                                                  particleType:ParticleTypeKilled];
//    [killedParticle setIsEmitting:1];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [killedParticle setAlpha:3.0f];//最初は濃く
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.5f//次に徐々に薄く小さく
                                          animations:^{
                                              [killedParticle setAlpha:0.0f];
                                          }
                                          completion:^(BOOL finished){
                                              //終了時処理
                                              [killedParticle setIsEmitting:NO];
                                              [killedParticle removeFromSuperview];

                                          }];
                         
                     }];
    
    
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

-(KiraParticleView *)getMovingParticle:(int)kiraNo{//アイテムが動いている時のパーティクル
    return movingParticle;
//    if(kiraNo < [kiraMovingArray count]){
//        return [kiraMovingArray objectAtIndex:kiraNo];
//    }
//    return nil;
}

-(KiraParticleView *)getOccurredParticle{//アイテム発生時のパーティクル
    
    return occurredParticle;
}

-(KiraParticleView *)getKilledParticle{//アイテムが消滅した時のパーティクル
    
    return killedParticle;
}


@end
