//
//  MyMachineClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "MyMachineClass.h"
#import "ItemClass.h"

@implementation MyMachineClass

@synthesize itemType;

int unique_id;
int wingStatus;
int effectDuration;
CGPoint _center;
NSString *imageName;
-(id) init:(int)x_init size:(int)size{
    effectDuration = 10;//10回アニメーション
    wingStatus = 0;//翼の状態
    unique_id++;
    y_loc = 350;
    x_loc = x_init;
    hitPoint = 10000;
    offensePower = 1;
    defensePower = 0;
    originalSize = size;
    mySize = originalSize;//モード変更によるサイズ
    bigSize = mySize * 4;
    lifetime_count = 0;
    dead_time = -1;//死亡したら0にして一秒後にparticleを消去する
    weaponCount = 0;//攻撃力強化タイム(通常時はゼロ)
    magnetCount = 0;
    bigCount = 0;
    numOfBeam = 1;//通常時、最初はビームの数は1つ(１列)
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
    
    //status=GameClassのアイテム取得時と対応
//    status = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//              @"0",@"StatusWpBomb",//
//              @"0",@"StatusWpDiffuse",
//              @"0",@"StatusWpLaser",
//              @"0",@"StatusDfBarrier",
//              @"0",@"StatusDfShield",
//              @"0",@"StatusTlBomb",
//              @"0",@"StatusTlHeal",
//              @"0",@"StatusTlMagnet",
//              @"0",@"StatusTlBig",
//              @"0",@"StatusTlSmall",
//              @"0",@"StatusTlTransparancy",
//              nil];
    
//    status = [[NSMutableDictionary alloc]init];
    /*
     ItemTypeWeapon0,//0
     ItemTypeWeapon1,
     ItemTypeWeapon2,
     ItemTypeDeffense0,
     ItemTypeDeffense1,
     ItemTypeMagnet,
     ItemTypeBomb,
     ItemTypeHeal,
     ItemTypeBig,
     ItemTypeSmall,
     ItemTypeTransparency,
     ItemTypeYellowGold,
     ItemTypeGreenGold,
     ItemTypeBlueGold,
     ItemTypePurpleGold,
     ItemTypeRedGold
     */
    status = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              @"0", [NSNumber numberWithInt:ItemTypeWeapon0],//0
              @"0", [NSNumber numberWithInt:ItemTypeWeapon1],
              @"0", [NSNumber numberWithInt:ItemTypeWeapon2],
              @"0", [NSNumber numberWithInt:ItemTypeDeffense0],
              @"0", [NSNumber numberWithInt:ItemTypeDeffense1],
              @"0", [NSNumber numberWithInt:ItemTypeMagnet],
              @"0", [NSNumber numberWithInt:ItemTypeBomb],
              @"0", [NSNumber numberWithInt:ItemTypeHeal],
              @"0", [NSNumber numberWithInt:ItemTypeBig],
              @"0", [NSNumber numberWithInt:ItemTypeSmall],
              @"0", [NSNumber numberWithInt:ItemTypeTransparency],
              @"0", [NSNumber numberWithInt:ItemTypeYellowGold],
              @"0", [NSNumber numberWithInt:ItemTypeGreenGold],
              @"0", [NSNumber numberWithInt:ItemTypeBlueGold],
              @"0", [NSNumber numberWithInt:ItemTypePurpleGold],
              @"0", [NSNumber numberWithInt:ItemTypeRedGold],
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
    iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
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
//                         NSLog(@"windStatus = %d", wingStatus);
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
    if(magnetCount > 0){
        magnetCount--;
    }else{
//        magnetCount = 0;
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeMagnet]];
    }
    
    if(weaponCount > 0){
        weaponCount--;
    }else{
        numOfBeam = 1;
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeWeapon1]];
    }
    
    if(bigCount > 0){
        bigCount --;
    }else{
        mySize = originalSize;
        iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
        [status setObject:@"0" forKey:[NSNumber numberWithInt:ItemTypeBig]];
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
    /*
     *1列の場合は０が中心位置に、２列の場合は０が左、１が右、３列の場合、０が左、１が中心、２が右
     */
    switch (numOfBeam) {
        case 1:{
            [beamArray insertObject:[[BeamClass alloc] init:x
                                                     y_init:y
                                                      width:50
                                                     height:50]
                            atIndex:0];//全て最初に格納
            
            break;
        }
        case 2:{
            
            for(int i = 0; i < numOfBeam;i++){
                [beamArray insertObject:[[BeamClass alloc] init:x+(20*pow(-1,i+1))//(30*(-1)^i)
                                                         y_init:y
                                                          width:50
                                                         height:50]
                                atIndex:0];//全て最初に格納
            }
            break;
        }
        case 3:{
            
            for(int i = 0; i < numOfBeam;i++){
                [beamArray insertObject:[[BeamClass alloc] init:x+40*(i-1)//30*(i-1)
                                                         y_init:y
                                                          width:50
                                                         height:50]
                                atIndex:0];//全て最初に格納
            }
            break;
        }
    }
    
        
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

-(int)getStatus:(ItemType)_statusKey{
    NSString *returnStr = [status objectForKey:[NSNumber numberWithInt:_statusKey]];
    return [returnStr integerValue];
}
//edit status
-(void)setStatus:(NSString *)statusValue key:(ItemType)_statusKey{
    itemType = _statusKey;
    
//    NSLog(@"status: %@, key: %d", statusValue, itemType);
    [status setObject:statusValue forKey:[NSNumber numberWithInt:itemType]];
    
    
    
    //    iv.alpha = 0.1f;
    //    [UIView animateWithDuration:10.0f
    //                     animations:^{
    //                         iv.alpha = 0.6f;
    //                     }
    //                     completion:^(BOOL finished){
    //                         iv.alpha = 1.0f;
    //                     }];
    
    
    switch(_statusKey){
            
        case ItemTypeMagnet:{
            if([statusValue integerValue]){
                magnetCount = 500;
            }else{
                magnetCount = 0;
            }
            break;
        }
        case ItemTypeBig:{
            if([statusValue integerValue]){
                
                //bigger
                bigCount = 500;
                mySize = bigSize;
                iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
            }else{
                mySize = originalSize;
                iv.frame = CGRectMake(x_loc-mySize/2, y_loc-mySize/2, mySize, mySize);
            }
//            [UIView animateWithDuration:10.0f
//                             animations:^{
//                                 iv.frame = CGRectMake(x_loc-bigSize/2, y_loc-bigSize/2, bigSize, bigSize);
//                             }
//                             completion:^(BOOL finished){
//                                 //original size
//                                 iv.frame = CGRectMake(x_loc-originalSize/2, y_loc-originalSize/2, originalSize, originalSize);
//                             }];
            break;
        }
        case ItemTypeBomb:{
            break;
        }
        case ItemTypeDeffense0:{
            break;
        }
        case ItemTypeDeffense1:{
            break;
        }
        case ItemTypeHeal:{
            break;
        }
        case ItemTypeSmall:{
            break;
        }
        case ItemTypeTransparency:{
            break;
        }
        case ItemTypeWeapon0:{//wpBomb
            break;
        }
        case ItemTypeWeapon1:{//wpDiffuse
            //ビームが３列になるまでは追加取得可能(新規取得する毎にカウンターが初期化)
            if([statusValue integerValue]){
                
                if(numOfBeam < 3){
                    weaponCount = 500;
                    numOfBeam++;//max:3
                }
            }else{
                weaponCount = 0;
                numOfBeam = 1;
            }
            //            [self setNumOfBeam:numOfBeam];
            break;
        }
        case ItemTypeWeapon2:{//wpLaser
            break;
        }
        default:
            break;
    }
}

-(void)setNumOfBeam:(int)_numOfBeam{
    numOfBeam = _numOfBeam;
}

-(int)getNumOfBeam{
    
    return numOfBeam;
}


@end
