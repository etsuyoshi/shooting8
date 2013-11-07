//
//  ItemClass.h
//  Shooting4
//
//  Created by 遠藤 豪 on 13/10/02.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KiraParticleView.h"

typedef NS_ENUM(NSInteger, ItemType) {
    ItemTypeWeapon0,
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
};

@interface ItemClass : NSObject{

    int x_loc;
    int y_loc;
//    ItemType *type;
    int width;
    int height;
    Boolean isAlive;
    UIImageView *iv;
    CGRect rect;
    KiraParticleView *occurredParticle;
    KiraParticleView *killedParticle;
//    KiraParticleView *movingParticle;
    NSMutableArray *kiraMovingArray;//FIFO=>取り出す時に分かりやすいようにfromコントローラ

}

@property(nonatomic) ItemType type;
-(id)init:(ItemType)type x_init:(int)x_init y_init:(int)y width:(int)w height:(int)h;
-(id)init:(int)x_init y_init:(int)y width:(int)w height:(int)h;
-(id)init;

-(Boolean)getIsAlive;

-(Boolean)doNext;//particle発生時にtrueを返す

-(void)die;
-(void)setLocation:(CGPoint)loc;
-(void)setX:(int)x;
-(void)setY:(int)y;

-(CGPoint)getLocation;
-(int) getX;
-(int) getY;
-(UIImageView *)getImageView;
-(ItemType)getType;
-(void)setType:(ItemType)type;
-(KiraParticleView *)getMovingParticle:(int)kiraNo;
-(KiraParticleView *)getOccurredParticle;
-(KiraParticleView *)getKilledParticle;


@end
