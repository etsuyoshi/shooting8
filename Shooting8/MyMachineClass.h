//
//  MyMachineClass.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExplodeParticleView.h"
#import "DamageParticleView.h"
#import "BeamClass.h"
#import "ItemClass.h"


@interface MyMachineClass : NSObject{
    
    int x_loc;
    int y_loc;
    int machine_type;//機体の型
    int hitPoint;
    int maxHitPoint;
    int offensePower;//攻撃力
    int defensePower;//守備力：バリアー
    int mySize,bigSize,originalSize;
    int lifetime_count;
    int bomb_size;
    int dead_time;
    int magnetCount;
    int weapon0Count;//爆弾を投げられる時間
    int weapon1Count;//攻撃力強化できる時間
    int weapon2Count;//laser
    int defense0Count;//barrier
    int defense1Count;
    int transparancyCount;
    int bombCount;
    int bigCount;
    int healCount;
    int numOfBeam;
    Boolean isAlive;
    UIImageView *iv;
    CGRect rect;
    UIImageView *ivLaser;
    NSMutableArray *beamArray;
    ExplodeParticleView *explodeParticle;
    DamageParticleView *damageParticle;
    
    NSMutableDictionary *status;//可変ステータス
}

@property(nonatomic) ItemType itemType;

-(id)init:(int)x_init size:(int)size;
-(id)init;
-(void)setType:(int)_type;
-(void)setDamage:(int)damage location:(CGPoint)location;
-(int)getStatus:(ItemType)_statusKey;
-(void)setStatus:(NSString *)statusValue key:(ItemType)itemType;
-(void)setNumOfBeam:(int)_numOfBeam;
-(int)getNumOfBeam;
-(void)die:(CGPoint)loc;
-(int)getHitPoint;
-(Boolean)getIsAlive;
-(void)setSize:(int)s;
-(int)getSize;
-(void)doNext;
-(int)getDeadTime;
-(void)setLocation:(CGPoint)loc;
-(void)setX:(int)x;
-(void)setY:(int)y;

-(CGPoint) getLocation;
-(int) getX;
-(int) getY;
-(UIImageView *)getImageView;
-(UIImageView *)getLaserImageView;
-(ExplodeParticleView *)getExplodeParticle;
-(DamageParticleView *)getDamageParticle;


-(void)yieldBeam:(int)beam_type init_x:(int)x init_y:(int)y;
-(BeamClass *)getBeam:(int)i;
-(int)getBeamCount;

-(void)setOffensePow:(int)_val;
-(void)setDefensePow:(int)_val;
@end
