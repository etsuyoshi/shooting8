//
//  KiraParticleView.m
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/10/31.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "KiraParticleView.h"
#import "QuartzCore/QuartzCore.h"



@implementation KiraParticleView
@synthesize particleType;

- (id)initWithFrame:(CGRect)frame{
    self = [self initWithFrame:frame
                  particleType:ParticleTypeOccurred];
    return self;
}

- (id)initWithFrame:(CGRect)frame
       particleType:(ParticleType)_particleType
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
        
        particle.name = @"snow";
        particle.enabled = YES;
        
        particle.contentsRect = CGRectMake(0.00, 0.00, 1.00, 1.00);
        
        particle.magnificationFilter = kCAFilterTrilinear;
        particle.minificationFilter = kCAFilterLinear;
        particle.minificationFilterBias = 0.00;
        
        particle.color = [[UIColor colorWithRed:0.77 green:0.55 blue:0.60 alpha:0.55] CGColor];
        particle.redRange = 0.9;
        particle.greenRange = 0.8;
        particle.blueRange = 0.7;
        particle.alphaRange = 0.8;
        
        particle.lifetimeRange = 3.5f;//2.37;
        
        particle.velocityRange = 5.00;
        particle.xAcceleration = 1.00;
        particle.yAcceleration = -10.00;
        particle.zAcceleration = 12.00;
        
        // these values are in radians, in the UI they are in degrees
        particle.spin = 0.384;
        particle.spinRange = 0.925;
        particle.emissionLatitude = 1.745;
        particle.emissionLongitude = 1.745;
        particle.emissionRange = 3.491;
        
        switch(_particleType){
                
            case ParticleTypeOccurred:{
                
                particle.contents = (id) [[UIImage imageNamed: @"kira2.png"] CGImage];//円形
                
                //色を残す
                particle.redSpeed = 0.2;
                particle.greenSpeed = 0.4;
                particle.blueSpeed = 0.4;
                particle.alphaSpeed = 0.5;
                
                //大きめ
                particle.scale = 0.72;
                particle.scaleRange = 0.14;
                particle.scaleSpeed = -0.25;

                //拡散
                particle.velocity = -50.00;
                
                //密度薄く
                birthRate = 25;
                particle.birthRate = birthRate;

                break;
            }
            case ParticleTypeMoving:{
                particle.contents = (id) [[UIImage imageNamed: @"snow.png"] CGImage];//菱形：小
                
                //すぐに白くする場合
                particle.redSpeed = 0.92;//赤増加速度
                particle.greenSpeed = 0.84;
                particle.blueSpeed = 0.74;
                particle.alphaSpeed = 0.55;
                
                
                //大きさを小さく
                particle.scale = 0.3;
                particle.scaleRange = 0.1;
                particle.scaleSpeed = -0.1;
                
                //拡散しないように
                particle.velocity = 20.00;
                
                //密度薄く
                birthRate = 10;
                particle.birthRate = birthRate;

                break;
            }
            case ParticleTypeKilled:{
                particle.contents = (id) [[UIImage imageNamed: @"snow.png"] CGImage];//菱形：小
                
                //すぐに白くする場合
                particle.color = [[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0f] CGColor];
                particle.redSpeed = 0.92;//赤増加速度
                particle.greenSpeed = 0.84;
                particle.blueSpeed = 0.74;
                particle.alphaSpeed = 0.55;
                
                particle.redRange = 0;
                particle.greenRange = 0;
                particle.blueRange = 0;
                particle.alphaRange = 0;
                
                particle.xAcceleration = 0;
                particle.yAcceleration = 0;
                particle.zAcceleration = 0;
                
                particle.spin = 0.384;
                particle.spinRange = 0;
                particle.emissionLatitude = 0;
                particle.emissionLongitude = 0;
                particle.emissionRange = 0;
                
                //大きさを小さく
                particle.scale = 1.5f;
                particle.scaleRange = 0;
                particle.scaleSpeed = -1.0f;
                
                //拡散しないように
                particle.velocity = 0.00;
                particle.velocityRange = 0;
                
                //発生個数は1つ
                if(arc4random() % 2 == 0){
                    birthRate = 1;
                }else{
                    birthRate = 3;
                }
                
                particle.birthRate = birthRate;
                
                break;
            }
        }
        
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

//使用していない？
-(void)setParticleType:(ParticleType)_type{
    
//    int pattern = arc4random() % 5;
//    if(pattern == 0){
//        particle.contents = (id)[[UIImage imageNamed:@"kira"] CGImage];
//    }else if(pattern == 1){
//        particle.contents = (id)[[UIImage imageNamed:@"kira2"] CGImage];
//    }else if(pattern >= 2){
//        particle.contents = (id)[[UIImage imageNamed:@"snow"] CGImage];
//    }
    particleType = _type;
    switch(_type){
        case ParticleTypeOccurred:{
            [particleEmitter setValue:(id) [[UIImage imageNamed: @"kira2.png"] CGImage]
                           forKeyPath:@"emitterCells.snow.contents"];
            break;
        }
        case ParticleTypeMoving:{
            //色を早く白くする
            //        particle.redSpeed = 0.92;//赤増加速度
            //        particle.greenSpeed = 0.84;
            //        particle.blueSpeed = 0.74;
            //        particle.alphaSpeed = 0.55;
            
            //以下のパラメタがきいてない＝＞要調査:これらのパラメータはsetValueメソッドで対応できない？！
            [particleEmitter setValue:[NSNumber numberWithInt:0.92]
                           forKeyPath:@"emitterCells.snow.redSpeed"];
            [particleEmitter setValue:[NSNumber numberWithInt:0.84]
                           forKeyPath:@"emitterCells.snow.greenSpeed"];
            [particleEmitter setValue:[NSNumber numberWithInt:0.74]
                           forKeyPath:@"emitterCells.snow.blueSpeed"];
            [particleEmitter setValue:[NSNumber numberWithInt:0.55]
                           forKeyPath:@"emitterCells.snow.alphaSpeed"];

            //大きさを小さく
//            particle.scale = 0.72;
//            particle.scaleRange = 0.14;
//            particle.scaleSpeed = -0.25;
//            [particleEmitter setValue:[NSNumber numberWithInt:0.3]
//                           forKeyPath:@"emitterCells.snow.scale"];
//            [particleEmitter setValue:[NSNumber numberWithInt:0.1]
//                           forKeyPath:@"emitterCells.snow.scaleRange"];
//            [particleEmitter setValue:[NSNumber numberWithInt:-0.05]
//                           forKeyPath:@"emitterCells.snow.scaleSpeed"];
            
            //拡散しないように
//            particle.velocity = -50.00;
            [particleEmitter setValue:[NSNumber numberWithInt:20.0]
                           forKeyPath:@"emitterCells.snow.velocity"];
            
            //密度薄く
            [particleEmitter setValue:[NSNumber numberWithInt:1.0]
                           forKeyPath:@"emitterCells.snow.birthRate"];
            
            //形状
            [particleEmitter setValue:(id) [[UIImage imageNamed: @"snow.png"] CGImage]
                           forKeyPath:@"emitterCells.snow.contents"];
            break;
        }
        case ParticleTypeKilled:{
            
            break;
        }
    }

}
@end
