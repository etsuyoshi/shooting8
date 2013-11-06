//
//  EnemyClass.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/26.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//


#import "EnemyClass.h"
#import "UIView+Animation.h"

@implementation EnemyClass
@synthesize enemyType;

int unique_id;
-(id) init:(int)x_init size:(int)size{
    unique_id++;
    hitPoint = 50;
    mySize = size;
    y_loc = 0;//-mySize;//画面の外から発生させる
    x_loc = x_init;
    
    lifetime_count = 0;
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    isAlive = true;
    isDamaged = false;
    explodeParticle = nil;
    damageParticle  = nil;
    rect = CGRectMake(x_loc, y_loc, mySize, mySize);
    iv = [[UIImageView alloc]initWithFrame:rect];
    iv.center = CGPointMake(x_loc, y_loc);//位置を修正
    enemyType = arc4random() % 5;
    switch(enemyType){
        case EnemyTypeZou:{
            bomb_size = 20;
            iv.image = [UIImage imageNamed:@"mob_zou_01.png"];
            break;
        }
        case EnemyTypeTanu:{
            bomb_size = 30;
            iv.image = [UIImage imageNamed:@"mob_tanu_01.png"];
            break;
        }
        case EnemyTypePen:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_pen_01.png"];
            break;
        }
        case EnemyTypeMusa:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_musa_01.png"];
            break;
        }
        case EnemyTypeHari:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_hari_01.png"];
            break;
        }
    }
//    iv.alpha = 0.5;
    
    
    return self;
}
-(id) init{
    NSLog(@"call enemy class initialization");
    return [self init:0 size:50];
}

-(void)setDamage:(int)damage location:(CGPoint)location{
    damageParticle = [[DamageParticleView alloc] initWithFrame:CGRectMake(location.x, location.y, damage, damage)];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [damageParticle setAlpha:0.0f];//徐々に薄く
                     }
                     completion:^(BOOL finished){
                         //終了時処理
                         [damageParticle setIsEmitting:NO];
                         [damageParticle removeFromSuperview];
                     }];
    
//    damageParticle.center = CGPointMake(x_loc, y_loc);
    hitPoint -= damage;
    if(hitPoint < 0){
        [self die];
    }
}

-(void) die{
    //爆発用パーティクルの初期化
    explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, bomb_size, bomb_size)];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [explodeParticle setAlpha:0.0f];//徐々に薄く
                     }
                     completion:^(BOOL finished){
                         //終了時処理
                         [explodeParticle setIsEmitting:NO];
                         [explodeParticle removeFromSuperview];
                     }];
    
//    explodeParticle.center = CGPointMake(x_loc, y_loc);
    isAlive = false;
    dead_time ++;
//    NSLog(@"die exit");
}


-(int)getHitPoint{
    return hitPoint;
}

-(Boolean) getIsAlive{
    return isAlive;
}

-(void)setSize:(int)s{
    mySize = s;
}
-(int)getSize{
    return mySize;
}
-(void)setIsDamaged:(Boolean)_isDamaged{
    isDamaged = _isDamaged;
}
-(void)doNext{
    //初動：最初に呼び出される時のみ
    if(lifetime_count == 0){
        [iv moveTo:CGPointMake(x_loc - mySize/2, 500)
          duration:5.0f
            option:UIViewAnimationOptionCurveLinear];
    }
//    [self doNext:false];
//}
//-(void)doNext:(Boolean)isDamaged{

//    [iv removeFromSuperview];
//    NSLog(@"更新前 y = %d", y_loc);
    lifetime_count ++;//不要？
    if(!isAlive){
        dead_time ++;
        return;
    }
//    y_loc += mySize/6;//旧形式
//    y_loc = iv.center.y;
//    CALayer *mLayer = [iv.layer presentationLayer];
    //現在中心座標
    y_loc = ((CALayer *)[iv.layer presentationLayer]).position.y;//center = 240
    
    
//    iv = [[UIImageView alloc]initWithFrame:CGRectMake(x_loc, y_loc, mySize, mySize)];

    
    switch(enemyType){
        case EnemyTypeZou:{
            bomb_size = 20;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_zou_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_zou_02.png"];
            }
            break;
        }
        case EnemyTypeTanu:{
            bomb_size = 30;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_tanu_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_tanu_02.png"];
            }
            break;
        }
        case EnemyTypePen:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_pen_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_pen_02.png"];
            }
            break;
        }
        case EnemyTypeMusa:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_musa_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_musa_02.png"];
            }
            break;
        }
        case EnemyTypeHari:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_hari_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_hari_02.png"];
            }
            break;
        }
    }
    
    //最後にisDamagedを通常時に戻してあげる
    isDamaged = false;//ダメージを受けたときだけtrueにする
}

-(int) getDeadTime{
    return dead_time;
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
    return iv;
}

-(ExplodeParticleView *)getExplodeParticle{//死亡イフェクト
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    [explodeParticle setType:1];//敵用パーティクル設定
    return explodeParticle;
//    return nil;
}
-(DamageParticleView *)getDamageParticle{//被弾イフェクト
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    return damageParticle;
}

@end
