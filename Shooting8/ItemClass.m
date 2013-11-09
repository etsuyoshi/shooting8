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
    [iv moveBoundDuration:0 option:0];
    
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
