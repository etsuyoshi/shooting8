//
//  TestViewController.m
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/10/27.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//
//timerでの実行モード
//#define MODE1
//#define MODE2
//#define MODE3
//#define MODE4

//#define CATRANSACTION_TEST
//#define TEST_EFFECT
//#define ORBITPATH_TEST
//#define TRACK_TEST
//#define EXPLOSTION_TEST
//#define BOMB_TEST
#define MYMACHINE_TEST



#import "ExplodeParticleView.h"
#import "EnemyClass.h"
#import "ItemClass.h"
#import "CreateComponentClass.h"
#import "TestViewController.h"
#import "UIView+Animation.h"
#import "Effect.h"
#import <QuartzCore/QuartzCore.h>

@interface TestViewController ()

@end

@implementation TestViewController

UIView *uiv;
UIImageView *uiiv;
NSString *imageName;
NSTimer *tm;
NSMutableArray *uiArray;

#ifdef TRACK_TEST
    NSMutableArray *array_uiv;
    NSMutableArray *array_layer;
    NSMutableArray *array_item;
#endif


#ifdef MYMACHINE_TEST
UIImageView *ivAnimateEffect;
#endif

int counter;
UIView *circleView;
CALayer *mylayer;
UIView *viewLayerTest;
ExplodeParticleView *explodeParticle;


int tempCount = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    uiv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];//赤、大正方形
    [uiv setBackgroundColor:[UIColor colorWithRed:0.5f green:0 blue:0 alpha:0.5f]];
    [self.view addSubview:uiv];
    
    
    
    uiv.userInteractionEnabled = YES;
    UIPanGestureRecognizer *flick_frame = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(onFlickedFrame:)];
    
    [uiv addGestureRecognizer:flick_frame];
    
    
//    int diameter = 300;//直径
//    CGPoint saveCenter = self.view.center;
//    CGRect newFrame = CGRectMake(0, 0, diameter, diameter);//中心は後で修正
//    circleView = [[UIView alloc]initWithFrame:newFrame];
//    circleView.layer.cornerRadius = diameter / 2.0;
//    circleView.center = saveCenter;
////    circleView.layer.borderWidth = 3.0f;
////    circleView.layer.borderColor = [UIColor blueColor].CGColor;
//    [circleView setBackgroundColor:[UIColor colorWithRed:0.5f green:0.1f blue:0.1f alpha:0.9f]];
//    [self.view addSubview:circleView];
    
//    uiiv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    imageName = [NSString stringWithFormat:@"coin_red.png"];
//    uiiv.image = [UIImage imageNamed:imageName];
//    [self.view addSubview:uiiv];
    
    
    viewLayerTest = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];//紫、小正方形
    [viewLayerTest setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:viewLayerTest];
//    mylayer = [CALayer layer];
    mylayer = (CALayer*)(viewLayerTest.layer.presentationLayer);
//    mylayer = viewLayerTest.layer;

//    mylayer = [CALayer layer]; //mylayer declared in .h file
//    mylayer.bounds = CGRectMake(0, 0, 100, 100);
//    mylayer.position = CGPointMake(100, 100); //In parent coordinate
//    mylayer.backgroundColor = [UIColor redColor].CGColor;
//    mylayer.contents = (id)[UIImage imageNamed:@"glasses"].CGImage;
//    [self.view.layer addSublayer:mylayer];
    
    
    
    imageName = [NSString stringWithFormat:@"tool_bomb.png"];
    
    uiArray = [[NSMutableArray alloc]init];
    
#ifdef TRACK_TEST
    array_uiv = [[NSMutableArray alloc] init];
    array_layer = [[NSMutableArray alloc]init];
    array_item = [[NSMutableArray alloc]init];
#endif
    
    
    tm = [NSTimer scheduledTimerWithTimeInterval:0.1
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    {
        [CATransaction setAnimationDuration:2];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

//        viewLayerTest.layer.position=CGPointMake(200, 200);
//        viewLayerTest.layer.opacity=0.5;
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
        [anim setDuration:0.5f];
        anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, self.view.bounds.size.height)];
        
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        [viewLayerTest.layer addAnimation:anim forKey:@"position"];
        
//        mylayer.position=CGPointMake(200, 200);
//        mylayer.opacity=0.5;
    } [CATransaction commit];
    
    
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0.5f];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    
//    {
//        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//        [anim setDuration:3.0f];
//        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
//        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 420)];//myview.superview.bounds.size.height)];
//        
//        anim.removedOnCompletion = NO;
//        anim.fillMode = kCAFillModeForwards;
//        [myview.layer addAnimation:anim forKey:@"position"];//uiviewから生成したlayerをanimation
//        
//    }
//    [CATransaction commit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFlickedFrame:(UIPanGestureRecognizer*)gr {

    CGPoint point = [gr translationInView:uiv];
    
    CGPoint movedPoint = CGPointMake(uiv.center.x + point.x, uiv.center.y + point.y);
    uiv.center = movedPoint;
    [gr setTranslation:CGPointZero inView:uiv];//ここでself.viewを指定するのではなく、myMachineをセットする

    // 指が移動したとき、上下方向にビューをスライドさせる
    if (gr.state == UIGestureRecognizerStateChanged) {//移動中
    }else if (gr.state == UIGestureRecognizerStateEnded) {//指を離した時
    }
    
    counter = 0;
}

- (void)time:(NSTimer*)timer{
#ifdef MODE1
    if(counter > 10){
        [uiv moveTo:CGPointMake(0, 300)
           duration:3.0f
             option:0];
    }
#elif defined MODE2
    [self createBox];
    [self moveBox];
#elif defined MODE3
    if(counter == 0){
        [self animateChangeImage];
    }
#elif defined MODE4
    if(counter % 5 == 0){
//    if(counter == 0){
        [self explodeTest];
    }
#elif defined TRACK_TEST
    if([array_uiv count] == 0){//最初に100個作成
        [self createView:1];
    }
    if(counter % 50 == 0){//uivを動かすとcounterがゼロになるので実行される
        
        //５秒毎に一個作成
//        [self createView:1];//これをやらずにoccureAnimFreeOrbitを実行した段階で初期位置に移動する
        //５秒毎に発生したviewとuivのcenterが異なればuiv.centerへの移動アニメーションを実行させる
//        [self occureAnim];//createViewで生成した全てのビューに対して実行
//        [self occureViewAnimFreeOrbit];//array_uiv内のuiviewに対して、occureAnimの任意軌道版
        [self occureItemAnimFreeOrbit];//array_item内のitemClassのviewに対して、同様にアニメーション
        
        //trackさせる
        
        /*
         CATRANSACTION_TESTと変わらないのに、なぜかスタート位置が異なる
         (恐らく前アニメーションの終了状態の違い？！
         */
        
        
//        [CATransaction begin];
//        //        [CATransaction setAnimationDuration:0.5f];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        {
//            [CATransaction setAnimationDuration:2];
//            //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//            
//            //        viewLayerTest.layer.position=CGPointMake(200, 200);
//            //        viewLayerTest.layer.opacity=0.5;
//            
//            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//            [anim setDuration:0.5f];
//            anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
//            //            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width,
//            //                                                                 self.view.bounds.size.height)];
//            
//            anim.toValue = [NSValue valueWithCGPoint:uiv.center];
//            
//            
//            anim.removedOnCompletion = NO;
//            anim.fillMode = kCAFillModeForwards;
//            [viewLayerTest.layer addAnimation:anim forKey:@"position"];
//            
//            //        mylayer.position=CGPointMake(200, 200);
//            //        mylayer.opacity=0.5;
        
        
        
        
        
        
        
//        CGPoint kStartPos = ((CALayer *)[viewLayerTest.layer presentationLayer]).position;//viewLayerTest.center;//((CALayer *)[iv.layer presentationLayer]).position;
////        CGPoint kStartPos = mylayer.position;
//        CGPoint kEndPos = uiv.center;//CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
////                                      500);//iv.superview.bounds.size.height);//480);//
//        NSLog(@"x=%f, y=%f", kStartPos.x, kStartPos.y);
//        [CATransaction begin];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        [CATransaction setCompletionBlock:^{//終了処理
//            CAAnimation* animationKeyFrame = [viewLayerTest.layer animationForKey:@"track"];
//            if(animationKeyFrame){
//                //途中で強制終了せずにアニメーションが全て完了したら
//                NSLog(@"animation key frame already exit");
////                [viewLayerTest.layer removeAnimationForKey:@"track"];
//            }else{
//                //途中で何らかの理由で遮られた場合
//                NSLog(@"animation key frame not exit");
//            }
//            
//        }];
//        
//        {
//            
//            
//            [CATransaction setAnimationDuration:2];
//            //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//            
//            //        viewLayerTest.layer.position=CGPointMake(200, 200);
//            //        viewLayerTest.layer.opacity=0.5;
//            
//            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
//            [anim setDuration:0.5f];
//            anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
//            anim.toValue = [NSValue valueWithCGPoint:kEndPos];
//            
//            anim.removedOnCompletion = NO;
//            anim.fillMode = kCAFillModeForwards;
//            [viewLayerTest.layer addAnimation:anim forKey:@"track"];
        
            //任意軌道を飛ぶ場合
//            // CAKeyframeAnimationオブジェクトを生成
//            CAKeyframeAnimation *animation;
//            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//            animation.fillMode = kCAFillModeForwards;
//            animation.removedOnCompletion = NO;
//            animation.duration = 3.0;
//            
//            // 放物線のパスを生成
//            //    CGFloat jumpHeight = kStartPos.y * 0.2;
//            CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
//            CGMutablePathRef curvedPath = CGPathCreateMutable();
//            CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
//            CGPathAddCurveToPoint(curvedPath, NULL,
//                                  peakPos.x, peakPos.y,
//                                  (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
//                                  //                          kStartPos.x + jumpHeight/2, kStartPos.y - jumpHeight,
//                                  //                          kEndPos.x - jumpHeight/2, kStartPos.y - jumpHeight,
//                                  kEndPos.x, kEndPos.y);
//            
//            // パスをCAKeyframeAnimationオブジェクトにセット
//            animation.path = curvedPath;
//            
//            // パスを解放
//            CGPathRelease(curvedPath);
//            
//            // レイヤーにアニメーションを追加
//            [viewLayerTest.layer addAnimation:animation forKey:@"freeDown"];
            
//        }
//        [CATransaction commit];
    }
    
#elif defined CATRANSACTION_TEST//うまくいってる
    
    NSLog(@"y=%f", ((CALayer *)viewLayerTest.layer.presentationLayer).position.y);
    if(((CALayer *)viewLayerTest.layer.presentationLayer).position.y >= self.view.bounds.size.height - 10 ||
       counter % 50 == 0){//５秒に一回
        
        
        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.5f];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        {
            [CATransaction setAnimationDuration:2];
            //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            
            //        viewLayerTest.layer.position=CGPointMake(200, 200);
            //        viewLayerTest.layer.opacity=0.5;
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
            [anim setDuration:0.5f];
            anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewLayerTest.layer presentationLayer]).position];//現在位置
//            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width,
//                                                                 self.view.bounds.size.height)];
            
            anim.toValue = [NSValue valueWithCGPoint:uiv.center];
            
            
            anim.removedOnCompletion = NO;
            anim.fillMode = kCAFillModeForwards;
            [viewLayerTest.layer addAnimation:anim forKey:@"position"];
            
            //        mylayer.position=CGPointMake(200, 200);
            //        mylayer.opacity=0.5;
        } [CATransaction commit];
        
        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:1.5f];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        [CATransaction setCompletionBlock:^{
//            NSLog(@"die");
//            [uiv setBackgroundColor:[UIColor blueColor]];
//        }];
//        uiv.layer.position = CGPointMake(uiv.center.x,
//                                         self.view.bounds.size.height);
//        [CATransaction commit];
        
        
        
//        uiv.center = CGPointMake(0, 0);
//        CAMediaTimingFunction *tf;
//        tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:100.0f];
//        [CATransaction setAnimationTimingFunction:tf];
//        uiv.layer.position = CGPointMake(self.view.bounds.size.width,
//                                         self.view.bounds.size.height);
//        [CATransaction commit];
        
        
//        //http://mm-workmode.blogspot.jp/2011/11/coreanimation-catransaction.html
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:5.0];
//        uiv.frame = CGRectMake(200.0, 340.0, 100.0, 100.0);
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:1.0];
//        uiv.layer.opacity = 1.3;
//        [CATransaction commit];
//        [CATransaction commit];
        
    }
#elif defined TEST_EFFECT
    if(counter == 0){
        [self effectTest];
    }
#elif defined EXPLOSTION_TEST
    if(counter == 0){
        
        int x_loc = self.view.center.x;
        int y_loc = self.view.center.y;
        int bomb_size = 200;
//        ExplodeParticleView *ex = [[ExplodeParticleView alloc]init];
        explodeParticle = [[ExplodeParticleView alloc] initWithFrame:CGRectMake(x_loc, y_loc, bomb_size, bomb_size)];
//        explodeParticle set
        [UIView animateWithDuration:1.5f
                         animations:^{
                             [explodeParticle setAlpha:0.0f];//徐々に薄く
                         }
                         completion:^(BOOL finished){
                             //終了時処理
                             [explodeParticle setIsEmitting:NO];
                             [explodeParticle removeFromSuperview];
                         }];
        [self.view addSubview:explodeParticle];
        NSLog(@"explode");
    }
    
#elif defined BOMB_TEST
    
    if(counter == 0){
        
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,100, 100)];
        bombView.image = [UIImage imageNamed:@"bomb026"];
        //    bombView.center = [MyMachine getImageView].center;
        CGPoint kStartPos = bombView.center;//((CALayer *)[view.layer presentationLayer]).position;
        CGPoint kEndPos = CGPointMake(320, 480);//CGPointMake(self.view.center.x,//test: + arc4random() % 320 - 160,
//                                      bombView.center.y * 0.5f);
        [CATransaction begin];
        //    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setCompletionBlock:^{//終了処理
            //        [self animAirView:view];
            CAAnimation *animationKeyFrame = [bombView.layer animationForKey:@"position"];
            if(animationKeyFrame){
                //途中で終わらずにアニメーションが全て完了した場合
//                NSLog(@"bomb throwerd!!");
                //            [bombView removeFromSuperview];
            }else{
                //途中で何らかの理由で遮られた場合
//                NSLog(@"animation key frame not exit");
            }
            
        }];
        
        {
            
            // CAKeyframeAnimationオブジェクトを生成
            CAKeyframeAnimation *animation;
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.duration = 2.0f;
            
            // 放物線のパスを生成
            CGPoint peakPos = CGPointMake(kStartPos.x + arc4random() * 100 - 50,
                                          (kStartPos.y + kEndPos.y)/2.0f);//test
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
            CGPathAddCurveToPoint(curvedPath, NULL,
                                  peakPos.x, peakPos.y,
                                  (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                                  kEndPos.x, kEndPos.y);
            
            // パスをCAKeyframeAnimationオブジェクトにセット
            animation.path = curvedPath;
            
            // パスを解放
            CGPathRelease(curvedPath);
            
            // レイヤーにアニメーションを追加
            //                        [[[ItemArray objectAtIndex:i] getImageView].layer addAnimation:animation forKey:@"position"];
            [bombView.layer addAnimation:animation forKey:@"position"];
            
        }
        [CATransaction commit];
        
        //    [UIView animateWithDuration:3.0f
        //                     animations:^{
        //                         bombView.center = self.view.center;
        //                     }];
        
        [self.view bringSubviewToFront:bombView];
        [self.view addSubview:bombView];
    }
    
#elif defined MYMACHINE_TEST
    if(counter == 0){
        
        NSLog(@"start");
        //http://stackoverflow.com/questions/5475380/uiimageview-animation-is-not-displayed-on-view
        NSArray *imgArray = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"player.png"],
                             [UIImage imageNamed:@"player2.png"],
                             [UIImage imageNamed:@"player3.png"],
                             [UIImage imageNamed:@"player4.png"],
                             [UIImage imageNamed:@"player4.png"],
                             [UIImage imageNamed:@"player3.png"],
                             [UIImage imageNamed:@"player2.png"],
                             [UIImage imageNamed:@"player.png"],
                             nil];
        UIImageView *animationView = [[UIImageView alloc] initWithFrame:CGRectMake(124,204,72,72)];
        animationView.animationImages = imgArray;
        animationView.animationDuration = 1.0f; // アニメーション全体で3秒（＝各間隔は0.5秒）
        animationView.animationRepeatCount = 0;
        [animationView startAnimating]; // アニメーション開始!!
        animationView.image = [UIImage imageNamed:@"player.png"];//最終状態?
        [self.view addSubview:animationView];
        
        
        ivAnimateEffect = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 72, 72)];
        ivAnimateEffect.animationImages = [[NSArray alloc] initWithObjects:
                                           [UIImage imageNamed:@"kira.png"],
                                           [UIImage imageNamed:@"kira2.png"],
                                           [UIImage imageNamed:@"snow.png"], nil];
        ivAnimateEffect.animationDuration = 1.0f;
        ivAnimateEffect.animationRepeatCount = 0;
        [ivAnimateEffect startAnimating];
        [animationView addSubview:ivAnimateEffect];
        
        [self repeatAnimEffect:10];
        
//        [self.view addSubview:ivAnimateEffect];
        NSLog(@"complete");
    }

    
#else
    NSLog(@"aaa");
    //nothing
#endif
    
#ifdef ORBITPATH_TEST
    if(counter == 0){
        [self orbitPath];
    }
#endif
    counter ++;
}

-(void)effectTest{
    //uiv-center-circle->radius:Smaller
//    Effect *effect = [[Effect alloc]init];
//    [uiv addSubview:[effect getEffectView:EffectTypeStandard]];
    
//    UIImageView *ivTest = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [ivTest setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1f]];
//
//    CALayer *orbit1 = [CALayer layer];
//    orbit1.bounds = CGRectMake(0, 0, 200, 200);
//    orbit1.position = ivTest.center;
//    orbit1.cornerRadius = 100;
//    orbit1.borderColor = [UIColor redColor].CGColor;
//    orbit1.borderWidth = 1.5;
//    orbit1.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:0.3f].CGColor;
//    [ivTest.layer addSublayer:orbit1];
    
    
//    ivTest.image = [UIImage imageNamed:@"powerGauge2.png"];
    
//    [UIView animateWithDuration:1.0f
//                          delay:0.0f
//                        options:UIViewAnimationOptionRepeat
////                                |UIViewAnimationOptionAutoreverse
//                     animations:^{
//                         [UIView setAnimationRepeatCount: 3.0];
////                         ivTest.bounds = CGRectMake(0, 0, 1, 1);
//                         [[circleView layer] setFrame:CGRectMake(self.view.center.x, self.view.center.y, 1, 1)];
////                         circleView.layer.cornerRadius = 1.0f;
//                     }
//                     completion:^(BOOL finished){
//                         tempCount++;
//                         NSLog(@"counter=%d", tempCount);
//                     }];
////    [uiv addSubview:ivTest];
//    [uiv addSubview:circleView];
    
//    
//    //http://stackoverflow.com/questions/10669051/how-do-i-create-a-smoothly-resizable-circular-uiview
//    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 100, 100)];
//    circle.center = CGPointMake(100, 100);
//    circle.layer.cornerRadius=50;
//    [[circle layer] setBorderColor:[[UIColor orangeColor] CGColor]];
//    [[circle layer] setBorderWidth:2.0];
//    [[circle layer] setBackgroundColor:[[[UIColor orangeColor] colorWithAlphaComponent:0.5] CGColor]];
//    [[self view] addSubview:circle];
//    
//    CGFloat animationDuration = 1.0; // Your duration
//    CGFloat animationDelay = 0; // Your delay (if any)
//    
//    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//    [cornerRadiusAnimation setFromValue:[NSNumber numberWithFloat:50.0]]; // The current value
//    [cornerRadiusAnimation setToValue:[NSNumber numberWithFloat:10.0]]; // The new value
//    [cornerRadiusAnimation setDuration:animationDuration];
//    [cornerRadiusAnimation setBeginTime:CACurrentMediaTime() + animationDelay];
//    [cornerRadiusAnimation setRepeatCount:3.0f];
//    
//    // If your UIView animation uses a timing funcition then your basic animation needs the same one
//    [cornerRadiusAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    
//    // This will keep make the animation look as the "from" and "to" values before and after the animation
//    [cornerRadiusAnimation setFillMode:kCAFillModeBoth];
//    [[circle layer] addAnimation:cornerRadiusAnimation forKey:@"keepAsCircle"];
//    [[circle layer] setCornerRadius:10.0]; // Core Animation doesn't change the real value so we have to.
//    
//    [UIView animateWithDuration:animationDuration
//                          delay:animationDelay
//                        options:UIViewAnimationOptionCurveEaseInOut
////                                |UIViewAnimationOptionRepeat
//                     animations:^{
//                         [UIView setAnimationRepeatCount: 3.0];
//                         [[circle layer] setFrame:CGRectMake(50, 50, 20, 20)]; // Arbitrary frame ...
////                         circle.layer.frame = CGRectMake(50, 50, 0, 0);
//                         circle.center = CGPointMake(100, 100);
//                         // You other UIView animations in here...
//                     } completion:^(BOOL finished) {
//                         // Maybe you have your completion in here...
//                         [circle removeFromSuperview];
//                     }];
//    [uiv addSubview:circle];
    
    Effect *effect = [[Effect alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIView *circle = [effect getEffectView:EffectTypeStandard];
    [uiv addSubview:circle];
}
-(void)explodeTest{
    
    //ランダムに配置
    //急速に拡大
    //拡大速度をゆっくり
    //徐々に薄く
    
    
    int xinit = 100;
    int yinit = 100;
//    int trans = 50;
    int arc11 = 80;//arc4random() % trans - trans/2;//移動位置x
    int arc21 = 80;//arc4random() % trans - trans/2;//移動位置y
    
    int size = arc4random() % 50;
    size = MIN(size, 30);

    
    //100位置を示す
//    UIImageView *u = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [u setBackgroundColor:[UIColor blueColor]];
//    u.center = CGPointMake(xinit, yinit);
//    [self.view addSubview:u];

    UIView *sv = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 200,200)];
    [sv setBackgroundColor:[UIColor colorWithRed:0.5 green:0.8 blue:0.9 alpha:0.1f]];
    
    UIImageView *uiiv = [[UIImageView alloc]initWithFrame:CGRectMake(xinit,
                                                                     yinit,
                                                                     2, 2)];
    uiiv.center = CGPointMake(xinit, yinit);
    [uiiv setAlpha:1.0f];//init:0
//    UIImageView *uiiv = [[UIImageView alloc]initWithFrame:CGRectMake(arc4random() % 100,
//                                                                     arc4random() % 100,
//                                                                     100, 100)];
    uiiv.image = [UIImage imageNamed:@"smoke.png"];
    [UIView animateWithDuration:0.1f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut//early-slow-stop
                     animations:^{
                         uiiv.center = CGPointMake(xinit + arc11,
                                                   yinit + arc21);//center
                         uiiv.frame = CGRectMake(xinit + arc11 - size/2, yinit + arc21 - size/2,
                                                 size, size);//resize

                         
                         [uiiv setAlpha:0.5f];
                         [self.view sendSubviewToBack:uiiv];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.8f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              uiiv.frame = CGRectMake(xinit + arc11 - size*3/2,
                                                                      yinit + arc21 - size*3/2,
                                                                      size*3, size*3);
                                              [uiiv setAlpha:0.0f];
                                          }
                                          completion:^(BOOL finished){
                                              
                                              [uiiv removeFromSuperview];
                                          }];
                         
                         
                         
                     }];
    
    
    [sv addSubview:uiiv];
    [self.view addSubview:sv];
}

-(void)animateChangeImage{
//    uiiv.image = [UIImage imageNamed:(i % 2) ? @"3.jpg" : @"4.jpg"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 1.0f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFade;
//    
//    [uiiv.layer addAnimation:transition forKey:nil];

//UIViewAnimationOptionTransitionCrossDissolve
    [UIView transitionWithView:uiiv
                      duration:3.0f
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        uiiv.image = [UIImage imageNamed:imageName];
                    } completion:^(BOOL finished){
//                        counter++;
//                        if(counter % 2 == 0){
//                            //        uiiv.image = [UIImage imageNamed:@"tool_bomb.png"];
//                            imageName = @"tool_bomb.png";
//                            NSLog(@"tool_bomb.png");
//                        }else{
//                            //        uiiv.image = [UIImage imageNamed:@"coin_red"];
//                            imageName = @"coin_red.png";
//                            NSLog(@"coin_red");
//                        }
//                        [self animateChangeImage];
                        NSLog(@"finished");
                    }];
}

-(void)createBox{
    
#ifndef TEST
    CGRect rect = CGRectMake(arc4random() % (int)self.view.bounds.size.width, 0, 30, 30);
    UIView *newView = [CreateComponentClass createImageView:rect image:@"mob_tanu_01.png"];
    //    [[UIView alloc]initWithFrame:CGRectMake(arc4random() % (int)self.view.bounds.size.width, 0, 30, 30)];
    [newView setBackgroundColor:[UIColor colorWithRed:0.5f green:0 blue:0 alpha:0.5f]];
    
    [uiArray insertObject:newView atIndex:0];
    [self.view addSubview:[uiArray objectAtIndex:0]];
    if([uiArray count] > 10){
        [[uiArray lastObject] removeFromSuperview];
        [uiArray removeLastObject];
    }

#else
    EnemyClass *enemy = [[EnemyClass alloc]init];
    [enemy getImageView].center = CGPointMake(arc4random() % (int)self.view.bounds.size.width, 0);
    [uiArray insertObject:enemy atIndex:0];
    [self.view addSubview:[[uiArray objectAtIndex:0] getImageView]];
    if([uiArray count] > 100){
        [[[uiArray lastObject] getImageView] removeFromSuperview];
        [uiArray removeLastObject];
    }

#endif
    
}

-(void)moveBox{
#ifndef TEST
    for(int i = 0; i < [uiArray count] ;i++){
        ((UIView *)[uiArray objectAtIndex:i]).center =
            CGPointMake(((UIView *)[uiArray objectAtIndex:i]).center.x,
                        ((UIView *)[uiArray objectAtIndex:i]).center.y + 10);
    }
    CGPoint movedPoint = CGPointMake(uiv.center.x + 10, uiv.center.y + 10);
    uiv.center = movedPoint;//CGPointMake(uiv.center.x, uiv.center.y + 100);

#else
    
#ifdef MODE1
    
#else
    for(int i = 0; i < [uiArray count] ;i++){
        ((UIView *)[[uiArray objectAtIndex:i] getImageView]).center =
        CGPointMake(((UIView *)[[uiArray objectAtIndex:i] getImageView]).center.x,
                    ((UIView *)[[uiArray objectAtIndex:i] getImageView]).center.y + 30);
    }
#endif
    
#endif
    
}

-(void)orbitPath{//任意軌道上をアニメーションする
    CGPoint kStartPos = ((CALayer *)[uiv.layer presentationLayer]).position;
    CGPoint kEndPos = CGPointMake(self.view.bounds.size.width,
                                  kStartPos.y);
    // CAKeyframeAnimationオブジェクトを生成
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 1.0;
    
    // 放物線のパスを生成
    CGFloat jumpHeight = 80.0;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);
    CGPathAddCurveToPoint(curvedPath, NULL,
                          kStartPos.x + jumpHeight/2, kStartPos.y - jumpHeight,
                          kEndPos.x - jumpHeight/2, kStartPos.y - jumpHeight,
                          kEndPos.x, kEndPos.y);
    
    // パスをCAKeyframeAnimationオブジェクトにセット
    animation.path = curvedPath;
    
    // パスを解放
    CGPathRelease(curvedPath);
    
    // レイヤーにアニメーションを追加
    [uiv.layer addAnimation:animation forKey:nil];
}

#ifdef TRACK_TEST
-(void)createView:(int)c{
    UIView *viewInArray = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [viewInArray setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:((float)[array_uiv count]) /255.0f alpha:1.0f]];
    [self.view bringSubviewToFront:viewInArray];
    
    for(int i = 0 ;i < c;i ++){
        [self.view addSubview:viewInArray];
        [array_uiv addObject:viewInArray];
        
    }
    
    
    
    ItemClass *_item = [[ItemClass alloc] init:5
                                        x_init:30
                                        y_init:30
                                         width:70
                                        height:70];
    for(int i = 0; i < c;i++){
        [array_item addObject:_item];
        [self.view addSubview:[[array_item objectAtIndex:i] getImageView]];
    }
    
    
    /*
     
     tonarinoyatuurusei
     tonarinoyatuurusei
     tonarinoyatuurusei
     
     */
}


-(void) occureAnim{
    
    //createViewで発生させたビューを移動させる
    //NSTimerで毎カウント実行させて、見た目上、uivが動いたタイミングで他のviewInArrayも動かす
    UIView *viewInArray;
    for(int i = 0;i < [array_uiv count];i++){
//        NSLog(@"array count = %d", i);
        viewInArray = (UIView *)[array_uiv objectAtIndex:i];
        //座標位置が異なればアニメーションさせる
//        NSLog(@"judge at %d, uiv.x = %f, uiv.y = %f, x = %f, y = %f", i, uiv.center.x, uiv.center.y, viewInArray.center.x, viewInArray.center.y);
        if(uiv.center.x != viewInArray.center.x ||
           uiv.center.y != viewInArray.center.y){
            
//            NSLog(@"start anim at i=%d", i);
            
            [CATransaction begin];
            //        [CATransaction setAnimationDuration:0.5f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            {
                [CATransaction setAnimationDuration:2];
                //        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                
                //        viewLayerTest.layer.position=CGPointMake(200, 200);
                //        viewLayerTest.layer.opacity=0.5;
                
//                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"toCenterPosition"];
                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
                [anim setDuration:0.5f];
                anim.fromValue = [NSValue valueWithCGPoint:((CALayer *)[viewInArray.layer presentationLayer]).position];//現在位置
                //            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width,
                //                                                                 self.view.bounds.size.height)];
                
                anim.toValue = [NSValue valueWithCGPoint:uiv.center];
                
                
                anim.removedOnCompletion = NO;
                anim.fillMode = kCAFillModeForwards;
//                [viewLayerTest.layer addAnimation:anim forKey:@"toCenterPosition"];
                [viewInArray.layer addAnimation:anim forKey:@"position"];
                
                //        mylayer.position=CGPointMake(200, 200);
                //        mylayer.opacity=0.5;
            } [CATransaction commit];
        }

    }

}


-(void) occureViewAnimFreeOrbit{
    
    //createViewで発生させたビューを移動させる
    //NSTimerで毎カウント実行させて、見た目上、uivが動いたタイミングで他のviewInArrayも動かす
    UIView *viewInArray;
    for(int i = 0;i < [array_uiv count];i++){
        //        NSLog(@"array count = %d", i);
        viewInArray = (UIView *)[array_uiv objectAtIndex:i];
        //座標位置が異なればアニメーションさせる
        //        NSLog(@"judge at %d, uiv.x = %f, uiv.y = %f, x = %f, y = %f", i, uiv.center.x, uiv.center.y, viewInArray.center.x, viewInArray.center.y);
//        if(uiv.center.x != viewInArray.center.x ||
//           uiv.center.y != viewInArray.center.y){
        
            //            NSLog(@"start anim at i=%d", i);
            
            CGPoint kStartPos = ((CALayer *)[viewInArray.layer presentationLayer]).position;//viewInArray.center;//((CALayer *)[iv.layer presentationLayer]).position;
//        CGPoint kStartPos = ((CALayer *)[((UIView *)[array_uiv objectAtIndex:i]).layer presentationLayer]).position;
            CGPoint kEndPos = uiv.center;//CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
//                                          500);//iv.superview.bounds.size.height);//480);//
            [CATransaction begin];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
            [CATransaction setCompletionBlock:^{//終了処理
                
                
                
                CAAnimation* animationKeyFrame = [viewInArray.layer animationForKey:@"position"];
//                CAAnimation *animationKeyFrame = [((UIView *)[array_uiv objectAtIndex:i]).layer animationForKey:@"position"];
                if(animationKeyFrame){
                    //途中で遮られずにアニメーションが全て完了した場合
                    //            [self die];
//                    [viewInArray removeFromSuperview];
//                    [viewInArray.layer removeAnimationForKey:@"position"];   // 後始末:これをやるとviewが消える。
//                    NSLog(@"animation key frame already exit & die");
                }else{
                    //途中で何らかの理由で遮られた場合=>なぜかここに制御が移らない(既に終了している可能性濃厚)
//                    NSLog(@"animation key frame not exit");
                }
                
            }];
            
            {
                
                // CAKeyframeAnimationオブジェクトを生成
                CAKeyframeAnimation *animation;
                animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                animation.fillMode = kCAFillModeForwards;
                animation.removedOnCompletion = NO;
                animation.duration = 1.0;
                
                // 放物線のパスを生成
                //    CGFloat jumpHeight = kStartPos.y * 0.2;
                CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
                CGMutablePathRef curvedPath = CGPathCreateMutable();
                CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
                CGPathAddCurveToPoint(curvedPath, NULL,
                                      peakPos.x, peakPos.y,
                                      (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                                      kEndPos.x, kEndPos.y);
                
                // パスをCAKeyframeAnimationオブジェクトにセット
                animation.path = curvedPath;
                
                // パスを解放
                CGPathRelease(curvedPath);
                
                // レイヤーにアニメーションを追加
                [viewInArray.layer addAnimation:animation forKey:@"position"];
//                [((UIView *)[array_uiv objectAtIndex:i]).layer addAnimation:animation forKey:@"position"];
                
            }
            [CATransaction commit];
//        }
        
    }
    
}


-(void) occureItemAnimFreeOrbit{
    
    //createViewで発生させたビューを移動させる
    //NSTimerで毎カウント実行させて、見た目上、uivが動いたタイミングで他のviewInArrayも動かす
    UIView *viewInArray;
    for(int i = 0;i < [array_item count];i++){
        //        NSLog(@"array count = %d", i);
        viewInArray = (UIView *)[[array_item objectAtIndex:i] getImageView];
        //座標位置が異なればアニメーションさせる
        //        NSLog(@"judge at %d, uiv.x = %f, uiv.y = %f, x = %f, y = %f", i, uiv.center.x, uiv.center.y, viewInArray.center.x, viewInArray.center.y);
        //        if(uiv.center.x != viewInArray.center.x ||
        //           uiv.center.y != viewInArray.center.y){
        
        //            NSLog(@"start anim at i=%d", i);
        
        CGPoint kStartPos = ((CALayer *)[viewInArray.layer presentationLayer]).position;//viewInArray.center;//((CALayer *)[iv.layer presentationLayer]).position;
        //        CGPoint kStartPos = ((CALayer *)[((UIView *)[array_uiv objectAtIndex:i]).layer presentationLayer]).position;
        CGPoint kEndPos = uiv.center;//CGPointMake(kStartPos.x + arc4random() % 100 - 50,//iv.bounds.size.width,
        //                                          500);//iv.superview.bounds.size.height);//480);//
        [CATransaction begin];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [CATransaction setCompletionBlock:^{//終了処理
            
            
            
            CAAnimation* animationKeyFrame = [viewInArray.layer animationForKey:@"position"];
            //                CAAnimation *animationKeyFrame = [((UIView *)[array_uiv objectAtIndex:i]).layer animationForKey:@"position"];
            if(animationKeyFrame){
                //途中で遮られずにアニメーションが全て完了した場合
                //            [self die];
                //                    [viewInArray removeFromSuperview];
                //                    [viewInArray.layer removeAnimationForKey:@"position"];   // 後始末:これをやるとviewが消える。
//                NSLog(@"animation key frame already exit & die");
            }else{
                //途中で何らかの理由で遮られた場合=>なぜかここに制御が移らない(既に終了している可能性濃厚)
//                NSLog(@"animation key frame not exit");
            }
            
        }];
        
        {
            
            // CAKeyframeAnimationオブジェクトを生成
            CAKeyframeAnimation *animation;
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.duration = 1.0;
            
            // 放物線のパスを生成
            //    CGFloat jumpHeight = kStartPos.y * 0.2;
            CGPoint peakPos = CGPointMake((kStartPos.x + kEndPos.x)/2, kStartPos.y * 0.05);//test
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            CGPathMoveToPoint(curvedPath, NULL, kStartPos.x, kStartPos.y);//始点に移動
            CGPathAddCurveToPoint(curvedPath, NULL,
                                  peakPos.x, peakPos.y,
                                  (peakPos.x + kEndPos.x)/2, (peakPos.y + kEndPos.y)/2,
                                  kEndPos.x, kEndPos.y);
            
            // パスをCAKeyframeAnimationオブジェクトにセット
            animation.path = curvedPath;
            
            // パスを解放
            CGPathRelease(curvedPath);
            
            // レイヤーにアニメーションを追加
            [viewInArray.layer addAnimation:animation forKey:@"position"];
            //                [((UIView *)[array_uiv objectAtIndex:i]).layer addAnimation:animation forKey:@"position"];
            
        }
        [CATransaction commit];
        //        }
        
    }
    
}

#endif


#ifdef MYMACHINE_TEST
-(void)repeatAnimEffect:(int)repeatCount{
    ivAnimateEffect.center = CGPointMake(50, 50);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         ivAnimateEffect.center = self.view.bounds.origin;
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             if(repeatCount > 0){
                                 [self repeatAnimEffect:repeatCount-1];
                             }
                             NSLog(@"aaa");
                         }
                     }];

}

#endif

@end

