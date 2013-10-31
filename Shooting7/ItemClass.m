//
//  ItemClass.m
//  Shooting4
//
//  Created by 遠藤 豪 on 13/10/02.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ItemClass.h"
#import "KiraParticleView.h"

@implementation ItemClass

@synthesize type;

-(id) init:(int)x_init y_init:(int)y_init width:(int)w height:(int)h{
    
    y_loc = y_init;
    x_loc = x_init;
    width = w;
    height = h;
    isAlive = true;
    //動線上に表示するパーティクルの初期化
    kiraParticle = [[KiraParticleView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 10, 10)];
    //    iv.image = [UIImage imageNamed:@"beam.png"];
    
//    http://stackoverflow.com/questions/9395914/switch-with-typedef-enum-type-from-string
    type = arc4random() % 5;//[NSNumber numberWithInt:arc4random()];
    switch(type){
        case ItemTypeWeapon0:{//青：攻撃力上昇
//            rect = CGRectMake(x_loc, y_loc, w, h);
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"blue_item_yuri_big2.png"];
//            iv.image = [UIImage imageNamed:@"coin001_32.png"];
            break;
        }
        case ItemTypeWeapon1:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"blue_item_yuri_big2.png"];
            
            break;
        }
        case ItemTypeWeapon2:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"blue_item_yuri_big2.png"];
            break;
        }
        case ItemTypeDeffense0:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"blue_item_yuri_big2.png"];
            
            break;
        }
        case ItemTypeDeffense1:{
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"blue_item_yuri_big2.png"];
            
            break;
        }
        case ItemTypeBomb://黄：画面内敵全滅
        {
//            rect = CGRectMake(x_loc, y_loc, w, h);
            rect = CGRectMake(x_loc, y_loc, w, h);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
//            iv.image = [UIImage imageNamed:@"yellow_item_thunder2.png"];
            iv.image = [UIImage imageNamed:@"yellow_item_thunder.png"];
            break;
        }
        case ItemTypeHeal://赤：回復
        {
            rect = CGRectMake(x_loc, y_loc, w, h);
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"red.png"];
            break;
        }
        case ItemTypeYellowGold:
        {
            rect = CGRectMake(x_loc, y_loc, w*1/2, h*1/2);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin001_32.png"];
            break;
        }
        case ItemTypeGreenGold:
        {
            rect = CGRectMake(x_loc, y_loc, w*1/2, h*1/2);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin001_32.png"];
            break;
        }
        case ItemTypeBlueGold:
        {
            rect = CGRectMake(x_loc, y_loc, w*1/2, h*1/2);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin001_32.png"];
            break;
        }
        case ItemTypePurpleGold:
        {
            rect = CGRectMake(x_loc, y_loc, w*1/2, h*1/2);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin001_32.png"];
            break;
        }
        case ItemTypeRedGold:
        {
            rect = CGRectMake(x_loc, y_loc, w*1/2, h*1/2);//コインは解像度が低いのでサイズを小さくして表示する
            iv = [[UIImageView alloc]initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"coin001_32.png"];
            break;
        }
            
        case ItemTypeSweep:{
            
            break;
        }
    }
    
    return self;
}
-(id) init{
    NSLog(@"call enemy class initialization");
    return [self init:0 y_init:0 width:10 height:10];
}

-(Boolean) getIsAlive{
    return isAlive;
}

-(void)doNext{
    
    //移動
    y_loc++;
    
    //引寄せアイテム発動中でなければ
    iv.center = CGPointMake(x_loc, y_loc);
    
    
    //動線上にキラキラ表示
    kiraParticle = [[KiraParticleView alloc]initWithFrame:CGRectMake(x_loc, y_loc, 10, 10)];
    
}


-(void) die{
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

-(KiraParticleView *)getKiraParticle{
    
    return kiraParticle;
}


@end
