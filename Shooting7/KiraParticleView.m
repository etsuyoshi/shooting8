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

-(id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    isFinished = false;
    if (self) {
        // Initialization code
        //http://enharmonichq.com/tutorial-particle-systems-in-core-animation-with-caemitterlayer/
        particleEmitter = (CAEmitterLayer *) self.layer;
        particleEmitter.emitterPosition = CGPointMake(0, 0);//CGPointMake(frame.origin.x, frame.origin.y);//CGPointMake(0, 0);
        particleEmitter.emitterSize = CGSizeMake(3,3);//frame.size.width, frame.size.height);
        particleEmitter.renderMode = kCAEmitterLayerAdditive;
        
        CAEmitterCell *particle = [CAEmitterCell emitterCell];
        particle.birthRate = 100;//火や水に見せるためには数百が必要
        particle.lifetime = 0.5;//表示時間(秒)
        particle.lifetimeRange = 0;
        particle.color = [[UIColor colorWithRed: 1.0f green: 1.0f blue:1.0f alpha: 0.5f] CGColor];//透明白色
        //        particle.contents = (id) [[UIImage imageNamed: @"star.png"] CGImage];
        int pattern = arc4random() % 2;
        if(pattern == 0){
            particle.contents = (id) [[UIImage imageNamed: @"kira.png"] CGImage];
        }else if(pattern == 1){
            particle.contents = (id) [[UIImage imageNamed: @"kira2.png"] CGImage];
        }
        particle.name = @"damage";
        particle.velocity = 0;//流れる平均速度(dot)
        particle.velocityRange = 10;//速度の標準偏差
//        particle.emissionLongitude = -M_PI_2;//流れる方向(正：時計回り)
//        particle.emissionRange = -1 * M_PI_2;//流れる方向の標準偏差→流れないようにするには？
        particle.scale = 0.15f;//最大サイズ
        particle.scaleSpeed = 0.5f;//最大サイズになるまでのスピード
        particle.scaleRange = 1.0f;//最大サイズのレンジ
        particle.spin = 1.0f;//回転角度
        
        
        
        particleEmitter.emitterCells = [NSArray arrayWithObject: particle];
    }
    //    NSLog(@"%@", self);//<DWFParticleView: 0x92458e0; frame = (160 160; 150 150); layer = <CAEmitterLayer: 0x9243e50>>
    return self;
    
}


+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}



-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles:引数がyesならばbirthRateを200に、noならば0(消去)
    //    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0]
    //               forKeyPath:@"emitterCells.fire.birthRate"];
    if(isEmitting){
        isFinished = false;
    }else{
        isFinished = true;
    }
    
    
    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?100:0]
                   forKeyPath:@"emitterCells.damage.birthRate"];
    
    //    [particleEmitter setValue:[NSNumber numberWithInt:isEmitting?30:0] forKeyPath:@"emitterCells.particle.birthRate"];
}

-(Boolean)getIsFinished{
    return isFinished;
}
-(void)setType:(int)_type{
#ifdef DEBUG
    NSLog(@"setType start");
#endif
    type = _type;
    
    switch(type){
        case 0://自機は赤で前向き
            //            NSLog(@"explode at type = %d", type);
            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.5 green: 0.1 blue: 0.1 alpha: 0.1] CGColor]
                           forKeyPath:@"emitterCells.fire.color"];
            [particleEmitter setValue:[NSNumber numberWithDouble:-M_PI_2]
                           forKeyPath:@"emitterCells.fire.emissionLongitude"];
            break;
        case 1://敵機は青で後ろ向き
            //            NSLog(@"explode at type = %d", type);
            [particleEmitter setValue:(id)[[UIColor colorWithRed: 0.1 green: 0.1 blue: 0.5 alpha: 0.1] CGColor]
                           forKeyPath:@"emitterCells.fire.color"];
            [particleEmitter setValue:[NSNumber numberWithDouble:M_PI_2]
                           forKeyPath:@"emitterCells.fire.emissionLongitude"];
            
            break;
    }
    
    
    
    
    
    NSLog(@"setType exit");
    
}


@end
