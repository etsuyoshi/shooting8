//
//  KiraParticleView.h
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/10/31.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface KiraParticleView : UIView{
    //    CAEmitterLayer *fireEmitter;
    CAEmitterLayer *particleEmitter;
    Boolean isFinished;
    int type;
}

-(void)setIsEmitting:(BOOL)isEmitting;
-(Boolean)getIsFinished;
-(void)setType:(int)type;
@end
