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
    ItemTypeWeapon0,//0:bomb:done
    ItemTypeWeapon1,//1:diffuse:done
    ItemTypeWeapon2,//2:laser:done
    ItemTypeDeffense0,//3:done
    ItemTypeDeffense1,//4:not(never?)->change armor?
    ItemTypeMagnet,//5:done
    ItemTypeBomb,//6:done
    ItemTypeHeal,//7:done
    ItemTypeBig,//8:done
    ItemTypeSmall,//9:not(never?)
    ItemTypeTransparency,//10:done
    ItemTypeYellowGold,//11:done
    ItemTypeGreenGold,//12:done
    ItemTypeBlueGold,//13:done
    ItemTypePurpleGold,//14:done
    ItemTypeRedGold//15:done
};

@interface ItemClass : NSObject{

    int x_loc;
    int y_loc;
//    ItemType *type;
    int width;
    int height;
    int lifetime_count;
    Boolean isMagnetMode;
    Boolean isAlive;
    UIImageView *iv;
    CGRect rect;
    KiraParticleView *occurredParticle;
    KiraParticleView *killedParticle;
    KiraParticleView *movingParticle;
    NSMutableArray *kiraMovingArray;//FIFO=>取り出す時に分かりやすいようにfromコントローラ

}

@property(nonatomic) ItemType type;
-(id)init:(ItemType)type x_init:(int)x_init y_init:(int)y width:(int)w height:(int)h;
-(id)init:(int)x_init y_init:(int)y width:(int)w height:(int)h;
-(id)init;

-(Boolean)getIsAlive;
-(Boolean)getIsMagnetMode;
-(void) setIsMagnetMode:(Boolean)_isSweepMode;

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
