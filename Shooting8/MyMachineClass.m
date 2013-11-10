//
//  MyMachineClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "MyMachineClass.h"

@implementation MyMachineClass

int unique_id;
int wingStatus;
CGPoint _center;
NSString *imageName;
-(id) init:(int)x_init size:(int)size{
    wingStatus = 0;//翼の状態
    unique_id++;
    y_loc = 350;
    x_loc = x_init;
    hitPoint = 10000;
    offensePower = 1;
    defensePower = 0;
    mySize = size;
    lifetime_count = 0;
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    isAlive = true;
    explodeParticle = nil;
    damageParticle  = nil;
//    rect = CGRectMake(x_loc, y_loc, mySize, mySize);
    //x_loc,y_loc is center point
    rect = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
    iv = [[UIImageView alloc]initWithFrame:rect];
    iv.image = [UIImage imageNamed:@"player.png"];
//    machine_type = arc4random() % 3;
    beamArray = [[NSMutableArray alloc]init];
    
    //status
    status = [NSDictionary dictionaryWithObjectsAndKeys:
              @"0",@"StatusWpBomb",
              @"0",@"StatusWpDiffuse",
              @"0",@"StatusWpLaser",
              @"0",@"StatusTlBarrier",
              @"0",@"StatusTlShield",
              @"0",@"StatusTlBomb",
              @"0",@"StatusTlHeal",
              @"0",@"StatusTlMagnet",
              @"0",@"StatusTlBig",
              @"0",@"StatusTlSmall",
              @"0",@"StatusTlTransparancy",
              nil];

    
//    switch(machine_type){
//        case 0:
//            bomb_size = 20;
//            iv.image = [UIImage imageNamed:@"player.png"];
//            break;
//        case 1:
//            bomb_size = 30;
//            iv.image = [UIImage imageNamed:@"player2.png"];
//            break;
//        case 2:
//            bomb_size = 40;
//            iv.image = [UIImage imageNamed:@"player3.png"];
//            break;
//        case 3:
//            bomb_size = 40;
//            iv.image = [UIImage imageNamed:@"player4.png"];
//            break;
//    }
    
    
    return self;
}
-(id) init{
    NSLog(@"call mymachine class ""DEFAULT"" initialization");
    return [self init:0 size:50];
}

//edit status
-(void)setStatus:(NSString *)statusValue key:(NSString *)statusKey{
    [status setValue:statusValue forKey:statusKey];
    
}

-(UIView *)createEffect{//statusに応じたイフェクト
    CGRect rectEffect = CGRectMake(x_loc, y_loc, 100, 100);
    UIImageView *viewEffect = [[UIImageView alloc]initWithFrame:rectEffect];
    viewEffect.image = [UIImage imageNamed:@"powerGauge2.png"];
    viewEffect.center = CGPointMake(x_loc, y_loc);
    [UIView animateWithDuration:0.5f
                     animations:^{
                         viewEffect.frame = CGRectMake(x_loc, y_loc,
                                                      1, 1);
                         viewEffect.center = CGPointMake(x_loc, y_loc);
                         //image.frame = smaller
                     }
                     completion:^(BOOL finished){
                         
//                         [self createEffect];
                         //if(counter++ < 5){//repeat count
                         //[self createEffect];
                         //endif
                         [viewEffect removeFromSuperview];
                     }];
    
    return viewEffect;
}

-(void)setType:(int)_type{
    
    machine_type = _type;
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
    
    
    
    if(defensePower >= 0){
        if(hitPoint > 0){
            hitPoint -= damage;
            if(hitPoint < 0){
                [self die:location];
            }
        }else{
            [self die:location];
        }
    }else{
        defensePower --;
    }
}

-(void) die:(CGPoint) location{
    //爆発用パーティクルの初期化
    explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, bomb_size, bomb_size)];
    [UIView animateWithDuration:3.5f
                     animations:^{
                         [explodeParticle setAlpha:0.0f];//徐々に薄く
                     }
                     completion:^(BOOL finished){
                         //終了時処理
                         [explodeParticle setIsEmitting:NO];
                         [explodeParticle removeFromSuperview];
                         
                         [iv removeFromSuperview];
                     }];
    isAlive = false;
    dead_time ++;
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
-(void)startAnimate{
//    NSString *imageName = @"player.png";
    
//    [UIView transitionWithView:uiiv
//                      duration:3.0f
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^{
//                        uiiv.image = [UIImage imageNamed:@"tool_bomb.png"];
//                    } completion:^(BOOL finished){
//                        NSLog(@"finished");
//                    }];

    
    //test@http://sweettolife.com/questions/14865790/change-image-after-uiimageview-had-started-completed-animation
//    UIViewAnimationOptionTransitionCrossDissolve
    [UIView transitionWithView:iv
                      duration:3.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         iv.image = [UIImage imageNamed:imageName];

                     }
                     completion:^(BOOL finished){
                         if(finished){
                         NSLog(@"windStatus = %d", wingStatus);
                         wingStatus ++;
                         wingStatus %= 8;
                         
                         switch(wingStatus){//lifetime_count%8を引数に取る？
                                 //    switch (lifetime_count % 20){//タイマーの間隔による
                             case 0:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player.png"];
                                 break;
                             }
                             case 1:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player2.png"];
                                 break;
                             }
                             case 2:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player3.png"];
                                 break;
                             }
                             case 3:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player4.png"];
                                 break;
                             }
                             case 4:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player4.png"];
                                 break;
                             }
                             case 5:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player3.png"];
                                 break;
                             }
                             case 6:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player2.png"];
                                 break;
                             }
                             case 7:{
                                 imageName = [NSString stringWithFormat:@"%@",@"player.png"];
                                 break;
                             }
                         }
                         
                         [self startAnimate];
                         }
                     }];
}
-(void)doNext{
    
    //    [iv removeFromSuperview];
    //    NSLog(@"更新前 y = %d", y_loc);
    
//    NSLog(@"%d" , lifetime_count);
    
//            NSLog(@"machine iv generated");    
//    iv = [[UIImageView alloc]initWithFrame:CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize)];
    
//    
//    switch(machine_type){//lifetime_count%8を引数に取る？
    switch ((int)(lifetime_count/10) % 8){//タイマーの間隔による
        case 0:{
            iv.image = [UIImage imageNamed:@"player.png"];
            break;
        }
        case 1:{
            iv.image = [UIImage imageNamed:@"player2.png"];
            break;
        }
        case 2:{
            iv.image = [UIImage imageNamed:@"player3.png"];
            break;
        }
        case 3:{
            iv.image = [UIImage imageNamed:@"player4.png"];
            break;
        }
        case 4:{
            iv.image = [UIImage imageNamed:@"player4.png"];
            break;
        }
        case 5:{
            iv.image = [UIImage imageNamed:@"player3.png"];
            break;
        }
        case 6:{
            iv.image = [UIImage imageNamed:@"player2.png"];
            break;
        }
        case 7:{
            iv.image = [UIImage imageNamed:@"player.png"];
            break;
        }
    }
    
    lifetime_count ++;
    if(!isAlive){
        dead_time ++;
    }
    
    
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

-(ExplodeParticleView *)getExplodeParticle{
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    [explodeParticle setType:0];//自機用パーティクル設定
    
    return explodeParticle;
}
-(DamageParticleView *)getDamageParticle{
    //dieしていれば爆発用particleは初期化されているはず=>描画用クラスで描画(self.view addSubview:particle);
    return damageParticle;
}

-(void)yieldBeam:(int)beam_type init_x:(int)x init_y:(int)y{
//    BeamClass *beam = [[BeamClass alloc] init:x y_init:y width:50 height:50];
    //ビーム配列は先入先出(FIFO)
    [beamArray insertObject:[[BeamClass alloc] init:x
                                             y_init:y
                                              width:50
                                             height:50]
                    atIndex:0];
    
//    [beamArray addObject:beam];
//    if([beamArray count] > 10){
////        最後のビームを削除
//        [[[beamArray lastObject] getImageView] removeFromSuperview];
//        [beamArray removeLastObject];
////        [beamArray addObject:beam];
//    }
    for(int i = 0; i < [beamArray count] ; i++){
        if(![[beamArray objectAtIndex:i] getIsAlive]){
            [beamArray removeObjectAtIndex:i];
        }
    }
}
-(BeamClass *)getBeam:(int)i{
    return (BeamClass *)[beamArray objectAtIndex:i];
}

-(int)getBeamCount{
    return [beamArray count];
}

-(void)setOffensePow:(int)_power{
    offensePower = _power;
}

-(void)setDefensePow:(int)_power{
    defensePower = _power;
}


@end
