//
//  EnemyClass.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/26.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//


#import "EnemyClass.h"

@implementation EnemyClass

int unique_id;
-(id) init:(int)x_init size:(int)size{
    unique_id++;
    y_loc = 0;
    x_loc = x_init;
    hitPoint = 50;
    mySize = size;
    lifetime_count = 0;
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    isAlive = true;
    isDamaged = false;
    explodeParticle = nil;
    damageParticle  = nil;
    rect = CGRectMake(x_loc, y_loc, mySize, mySize);
    iv = [[UIImageView alloc]initWithFrame:rect];
    enemy_type = arc4random() % 5;
    switch(enemy_type){
        case 0:{
            bomb_size = 20;
            iv.image = [UIImage imageNamed:@"mob_zou_01.png"];
            break;
        }
        case 1:{
            bomb_size = 30;
            iv.image = [UIImage imageNamed:@"mob_tanu_01.png"];
            break;
        }
        case 2:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_pen_01.png"];
            break;
        }
        case 3:{
            bomb_size = 40;
            iv.image = [UIImage imageNamed:@"mob_musa_01.png"];
            break;
        }
        case 4:{
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
    hitPoint -= damage;
    if(hitPoint < 0){
        [self die:location];
    }
}

-(void) die:(CGPoint) location{
    //爆発用パーティクルの初期化
    explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(location.x, location.y, bomb_size, bomb_size)];
    isAlive = false;
    dead_time ++;
    NSLog(@"die exit");
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
    
//    [iv removeFromSuperview];
//    NSLog(@"更新前 y = %d", y_loc);
    lifetime_count ++;//不要？
    if(!isAlive){
        dead_time ++;
    }
    

    if(y_loc <= 100){//衝突判定テストのため
            y_loc += mySize/6;
//            x_loc += mySize/10 * (int)pow(-1, arc4random()%2) % 200;//単位時間当たりに左右3個体分の移動距離を進む
    }else{
        //タイプによって進むものとそうでないものに分ける
        
        switch(enemy_type){
            case 0:{
                y_loc += mySize/6;
//                x_loc += mySize/10 * (int)pow(-1, arc4random()%2) % 200;//単位時間当たりに左右3個体分の移動距離を進む
                break;
            }
            case 1:{
                y_loc += mySize/6;
//                x_loc += mySize/10 * (int)pow(-1, arc4random()%2) % 200;//単位時間当たりに左右3個体分の移動距離を進む
                break;
            }
            case 2:{
                y_loc += mySize/6;
                //                x_loc += mySize/10 * (int)pow(-1, arc4random()%2) % 200;//単位時間当たりに左右3個体分の移動距離を進む
                break;
            }
            case 3:{
                
                break;
            }
            case 4:{
                break;
            }
        }
    }
    
    
    
    iv = [[UIImageView alloc]initWithFrame:CGRectMake(x_loc, y_loc, mySize, mySize)];

    
    switch(enemy_type){
        case 0:{
            bomb_size = 20;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_zou_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_zou_02.png"];
            }
            break;
        }
        case 1:{
            bomb_size = 30;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_tanu_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_tanu_02.png"];
            }
            break;
        }
        case 2:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_pen_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_pen_02.png"];
            }
            break;
        }
        case 3:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_musa_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_musa_02.png"];
            }
            break;
        }
        case 4:{
            bomb_size = 40;
            if(!isDamaged){
                iv.image = [UIImage imageNamed:@"mob_hari_01.png"];
            }else{
                iv.image = [UIImage imageNamed:@"mob_hari_02.png"];
            }
            break;
        }
    }
//    switch(enemy_type){
//        case 0:
////            iv.image = [UIImage imageNamed:@"enemy01_stand_128.png"];//mechanical_design_3
//            iv.image = [UIImage imageNamed:@"test_teki_rough.png"];
//            break;
//        case 1:
////            iv.image = [UIImage imageNamed:@"enemy02_stand_128.png"];
//            iv.image = [UIImage imageNamed:@"test_teki_rough.png"];
//            break;
//        case 2:
//            iv.image = [UIImage imageNamed:@"test_teki_rough.png"];
//            break;
//    }


//    NSLog(@"更新後 y = %d", y_loc);
//    rect = CGRectMake(x_loc, y_loc, mySize, mySize);
//    iv = [[UIImageView alloc]initWithFrame:rect];
    
    
    
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
