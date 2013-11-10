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
#define TEST_EFFECT

#define TEST
#import "EnemyClass.h"
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
int counter;
UIView *circleView;


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
    
    uiv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
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
    
    
    
    
    
    imageName = [NSString stringWithFormat:@"tool_bomb.png"];
    
    uiArray = [[NSMutableArray alloc]init];
    tm = [NSTimer scheduledTimerWithTimeInterval:0.1
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];
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
#elif defined TEST_EFFECT
    if(counter == 0){
        [self effectTest];
    }
#else
    NSLog(@"aaa");
    //nothing
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

@end
