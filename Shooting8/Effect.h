//
//  Effect.h
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/10.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EffectType) {
    EffectTypeStandard,
    EffectTypeHeal
};


@interface Effect : NSObject{
    //field
}
//@property(nonatomic) EffectType effectType;

-(id)initWithFrame:(CGRect)_rect;
-(UIView *)getEffectView:(EffectType)effectType;
-(void)occurEffect:(int)duraiton;
@end
