//
//  KiraParticleView.m
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/10/31.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "KiraParticleView.h"
#import "QuartzCore/QuartzCore.h"


int birthRate = 5;
@implementation KiraParticleView

- (id)initWithFrame:(CGRect)frame
//          birthRate:(int)birthRate
//           lifetime:(float)lifetime
//       lifetimeRage:(float)lifetimeRange
//              color:(UIColor*)color
//           contents:(NSString*)contents
//               name:(NSString*)name
//           velocity:(int)velocity
{
    self = [super initWithFrame:frame];
    
    //CAEmitterLayer自体の生存パラメータ(particle自体のものではない)
    lifeTime = 0;//生存時間
    isAlive = true;//生存判定
    lifeSpan = 10;//寿命=>コントローラー側のカウント
    if (self) {
        // Initialization code
        //        定義：CAEmitterLayer *particleEmitter;@global変数
        //origin
        particleEmitter = (CAEmitterLayer *) self.layer;//frame位置が認識され表示位置が確定される
        particleEmitter.emitterPosition = CGPointMake(0,0);//frame.origin.x, frame.origin.y);//CGPointMake(0, 0);
        particleEmitter.emitterSize = CGSizeMake(10, 10);//frame.size.width, frame.size.height
        particleEmitter.renderMode = kCAEmitterLayerAdditive;
        
        
        //github
        //        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        //        particleEmitter.name = @"snowLayer";
        particleEmitter.emitterPosition = CGPointMake(CGRectGetMidX([self bounds]), 10);
        particleEmitter.emitterZPosition = -43;
        particleEmitter.emitterSize = CGSizeMake([self bounds].size.width, 10.00);
        particleEmitter.emitterDepth = 0.00;
        particleEmitter.emitterShape = kCAEmitterLayerCircle;
        particleEmitter.emitterMode = kCAEmitterLayerSurface;
        particleEmitter.renderMode = kCAEmitterLayerBackToFront;
        particleEmitter.seed = arc4random();
        
        
        //github
        CAEmitterCell *particle = [CAEmitterCell emitterCell];
        //origin
        //        particle.birthRate = 200;
        //        particle.lifetime = 2.0;
        //        particle.lifetimeRange = 1.5;
        //        particle.color = [[UIColor colorWithRed: 0.2 green: 0.4 blue: 0.8 alpha: 0.1] CGColor];
        //        particle.contents = (id) [[UIImage imageNamed: @"kira.png"] CGImage];
        //        particle.name = @"particle";
        //        particle.velocity = 150;
        //        particle.velocityRange = 100;
        //        particle.emissionRange = M_PI_2;
        //        particle.emissionLongitude = 0.025 * 180 / M_PI;
        //        particle.scale = 0.3f;
        //        particle.scaleRange = 0;
        //        particle.scaleSpeed = 0;
        //        particle.spin = 0.5;
        
        particle.name = @"snow";
        particle.enabled = YES;
        
        int pattern = arc4random() % 5;
        if(pattern == 0){
            particle.contents = (id)[[UIImage imageNamed:@"kira"] CGImage];
        }else if(pattern == 1){
            particle.contents = (id)[[UIImage imageNamed:@"kira2"] CGImage];
        }else if(pattern >= 2){
            particle.contents = (id)[[UIImage imageNamed:@"snow"] CGImage];
        }
        particle.contentsRect = CGRectMake(0.00, 0.00, 1.00, 1.00);
        
        particle.magnificationFilter = kCAFilterTrilinear;
        particle.minificationFilter = kCAFilterLinear;
        particle.minificationFilterBias = 0.00;
        
        particle.scale = 0.72;
        particle.scaleRange = 0.14;
        particle.scaleSpeed = -0.25;
        
        particle.color = [[UIColor colorWithRed:0.77 green:0.55 blue:0.60 alpha:0.55] CGColor];
        //        particle.redRange = 0.09;
        //        particle.greenRange = 0.08;
        //        particle.blueRange = 0.07;
        //        particle.alphaRange = 0.08;
        particle.redRange = 0.9;
        particle.greenRange = 0.8;
        particle.blueRange = 0.7;
        particle.alphaRange = 0.8;
        
        //色を残す場合
        particle.redSpeed = 0.2;
        particle.greenSpeed = 0.4;
        particle.blueSpeed = 0.4;
        particle.alphaSpeed = 0.5;
        //すぐに白くする場合
        //        particle.redSpeed = 0.92;//赤増加速度
        //        particle.greenSpeed = 0.84;
        //        particle.blueSpeed = 0.74;
        //        particle.alphaSpeed = 0.55;
        
        particle.lifetime = 10.0f;
        particle.lifetimeRange = 10.5f;//2.37;
        particle.birthRate = birthRate;
        particle.velocity = -20.00;
        particle.velocityRange = 20.00;
        particle.xAcceleration = 1.00;
        particle.yAcceleration = -10.00;
        particle.zAcceleration = 12.00;
        
        // these values are in radians, in the UI they are in degrees
        particle.spin = 0.384;
        particle.spinRange = 0.925;
        particle.emissionLatitude = 1.745;
        particle.emissionLongitude = 1.745;
        particle.emissionRange = 3.491;
        
        particleEmitter.emitterCells = [NSArray arrayWithObject: particle];
    }
    return self;
}

-(void)doNext{
    lifeTime++;
    if(lifeTime >= lifeSpan){
        isAlive = false;
    }
}
-(int)getLifeTime{
    return lifeTime;
}
-(Boolean)getIsAlive{
    return isAlive;
}
-(void)setLifeSpan:(int)_lifeSpan{
    lifeSpan = _lifeSpan;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

+ (Class)layerClass
{
    return [CAEmitterLayer class];
}


-(void)setIsEmitting:(BOOL)isEmitting
{
    //    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0]
    //                   forKeyPath:@"emitterCells.particle.birthRate"];
    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?birthRate:0]
                   forKeyPath:@"emitterCells.snow.birthRate"];
}
@end
