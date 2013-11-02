//
//  KiraParticleView.h
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/10/31.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
typedef NS_ENUM(NSInteger, ParticleType) {
    ParticleTypeOccurred,
    ParticleTypeMoving,
    ParticleTypeKilled
};

@interface KiraParticleView : UIView{
    CAEmitterLayer *particleEmitter;
    int lifeTime;
    Boolean isAlive;
    int lifeSpan;
    int birthRate;
}
@property(nonatomic) ParticleType particleType;
-(id)initWithFrame:(CGRect)frame particleType:(ParticleType)_particleType;
-(void)setIsEmitting:(BOOL)isEmitting;
-(void)doNext;
-(int)getLifeTime;
-(Boolean)getIsAlive;
-(void)setLifeSpan:(int)_lifeSpan;
@end
