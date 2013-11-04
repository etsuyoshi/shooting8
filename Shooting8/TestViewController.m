//
//  TestViewController.m
//  Shooting7
//
//  Created by 遠藤 豪 on 2013/10/27.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#define TEST
#import "EnemyClass.h"
#import "CreateComponentClass.h"
#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

UIView *uiv;
NSTimer *tm;
NSMutableArray *uiArray;

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
}

- (void)time:(NSTimer*)timer{
    [self createBox];
    [self moveBox];
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
    for(int i = 0; i < [uiArray count] ;i++){
        ((UIView *)[[uiArray objectAtIndex:i] getImageView]).center =
        CGPointMake(((UIView *)[[uiArray objectAtIndex:i] getImageView]).center.x,
                    ((UIView *)[[uiArray objectAtIndex:i] getImageView]).center.y + 30);
    }
    
#endif
}

@end
