//
//  GameClassViewController.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//  敵機がランダムに動く中で、タップすると自機が移動、フリックさせるとビーム発射
//背景参考：http://dixq.net/rp/20.html


//アニメーションは以下の方が速いかもしれない。スムーズ(但し逐次位置は把握できない？)
//http://iphone-tora.sakura.ne.jp/uiview.html

/**
 ・敵機からビーム発射及び自機との接触イベント(敵機と自機の接触イベントも同じように出来れば尚よし)
 ・画面構成：一時停止ボタン：済(再開リアクション：済)、点数表示:済、機数(生き返り数)：ラベルはgradius5.jpg、パワーゲージ(自機耐久力＝死ににくいようにする必要、ビーム強力度)
 ・敵機にhitPoint：済、Beamにpowerを持たせて：済、当たった分だけダメージを与える：済、ダメージ発生時、簡単なparticleを表示：済
 ・敵機と衝突判定、衝突した後の生き返り時のリアクション(alpha修正により半透明にする)
 ・敵機倒した時にアイテムを生成：済、アイテムを精密に→CW
 ・敵機の描画を精密に？！→クラウドワークス
 ・画面タッチ時にビーム発射：済

 ・敵機をもっと頑丈に(typeによって爆発hit数を変更する):済
 ・自機からのビームはタップ時常時発射:済
 ・自機の移動はpanGesture:済
 */

#import "BGMClass.h"
#import "GameClassViewController.h"
#import "DBAccessClass.h"
#import "AttrClass.h"
#import "CreateComponentClass.h"
#import "EnemyClass.h"
//#import "BeamClass.h"
#import "ItemClass.h"
#import "DWFParticleView.h"
#import "PowerGaugeClass.h"
#import "MyMachineClass.h"
#import "ScoreBoardClass.h"
#import "GoldBoardClass.h"
#import <QuartzCore/QuartzCore.h>
#define TIMEOVER_SECOND 100
#define OBJECT_SIZE 70//自機と敵機のサイズ


CGRect rect_frame, rect_myMachine, rect_enemyBeam, rect_beam_launch;
UIImageView *iv_frame, *iv_myMachine, *iv_enemyBeam, *iv_beam_launch, *iv_background1, *iv_background2;

UIView *_loadingView;
UIActivityIndicatorView *_indicator;

int world_no;


//NSMutableArray *iv_arr_tokuten;
int y_background1, y_background2;
const int explosionCycle = 10;//爆発時間
int max_enemy_in_frame;
int x_frame, y_frame;
//int x_myMachine, x_enemyMachine, x_beam;
//int y_myMachine, y_enemyMachine, y_beam;
int size_machine;
int length_beam, thick_beam;//ビームの長さと太さ
Boolean isGameMode;


UIPanGestureRecognizer *panGesture;
//UILongPressGestureRecognizer *longPress_frame;
Boolean isTouched;

MyMachineClass *MyMachine;
NSMutableArray *EnemyArray;
//NSMutableArray *BeamArray;
NSMutableArray *ItemArray;
ScoreBoardClass *ScoreBoard;
GoldBoardClass *GoldBoard;

int enemyCount;//発生した敵の数
int enemyDown;//倒した敵の数

//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//パワーゲージ背景：ビジュアルこだわりポイント
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
PowerGaugeClass *powerGauge;//imageviewを内包
UIImageView *iv_powerGauge;
UIImageView *iv_pg_ribrary;
UIImageView *iv_pg_circle;
UIImageView *iv_pg_cross;
int x_pg, y_pg, width_pg, height_pg;


NSTimer *tm;
BGMClass *bgmClass;
float count = 0;

@interface GameClassViewController ()

@end




@implementation GameClassViewController

@synthesize soundURL;
@synthesize soundID;


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
    
    //ステージ選択
    world_no = arc4random() % 6;
    
    //BGM START=0.1second-delay
    [self performSelector:@selector(playBGM) withObject:nil afterDelay:0.1];

    
    //UI編集：ナビゲーションボタンの追加＝一時停止
    
    UIBarButtonItem* right_button_stop = [[UIBarButtonItem alloc] initWithTitle:@"stop"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
//                                                                         action:@selector(alertView:clickedButtonAtIndex:)];
                                                                         action:@selector(onClickedStopButton)];
    UIBarButtonItem* right_button_setting = [[UIBarButtonItem alloc]
                                             initWithTitle:@"set"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(onClickedSettingButton)];
    
    isGameMode = true;
    isTouched = false;
    self.navigationItem.rightBarButtonItems = @[right_button_stop, right_button_setting];
    self.navigationItem.leftItemsSupplementBackButton = YES; //戻るボタンを有効にする
    
    max_enemy_in_frame = 20;
    
    
    //タッチ用パネル(タップ＆フリックで自機移動、タップしている間はビーム発射)
    rect_frame = [[UIScreen mainScreen] bounds];
    NSLog(@"%d", (int)[iv_frame center].x);
    x_frame = rect_frame.size.width;
    y_frame = rect_frame.size.height;
    NSLog(@"%d, %d", x_frame, y_frame);
    iv_frame = [[UIImageView alloc]initWithFrame:rect_frame];
//    iv_frame.image =[UIImage imageNamed:@"gameover.png"];
    iv_frame.userInteractionEnabled = YES;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(onFlickedFrame:)];
    //LongPressGestureRecogを付けてしまうとtouchesEnded:メソッドが実行されないかも？
    //もしやるとしたら→http://teru2-bo2.blogspot.jp/2012/04/uilongpressgesturerecognizer.html
//    longPress_frame=
//        [[UILongPressGestureRecognizer alloc]initWithTarget:self
//                                                     action:@selector(onLongPressedFrame:)];
//    UITapGestureRecognizer *tap_frame = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                action:@selector(onTappedFrame:)];
    [iv_frame addGestureRecognizer:panGesture];
//    [iv_frame addGestureRecognizer:longPress_frame];
    
//    [iv_frame addGestureRecognizer:tap_frame];
    [self.view bringSubviewToFront: iv_frame];//最前面に
    //ビューにメインイメージを貼り付ける
    [self.view addSubview:iv_frame];

    
    //backgroundの描画：絵を二枚用意して一枚目を表示して時間経過と共に進行方向(逆)にスクロールさせ、１枚目の終端を描画し始めたら２枚目の最初を描画させる
    iv_background1 = [[UIImageView alloc]initWithFrame:rect_frame];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(rect_frame.origin.x,
                                                                  -rect_frame.size.height,
                                                                  rect_frame.size.width,
                                                                  rect_frame.size.height)];
    [self.view addSubview:iv_background1];//初期状態ではまず１枚目を描画させる
    [self.view addSubview:iv_background2];
    y_background1 = 0;
    y_background2 = -rect_frame.size.height;

    
    length_beam = 20;
    thick_beam = 5;
    
    //敵の発生時の格納箱初期化
    EnemyArray = [[NSMutableArray alloc]init];
    
    //自機定義
    MyMachine = [[MyMachineClass alloc] init:x_frame/2 size:OBJECT_SIZE];
    
    //自機が発射したビームを格納する配列初期化=>MyMachineクラス内に実装
//    BeamArray = [[NSMutableArray alloc] init];
    
    //敵機を破壊した際のアイテム
    ItemArray = [[NSMutableArray alloc] init];
    
    //スコアボードの初期化
    ScoreBoard = [[ScoreBoardClass alloc]init:0 x_init:0 y_init:0 ketasu:10];
    
    //スコアボードの表示(初期状態ではゼロ)
    [self displayScore:ScoreBoard];
    
    //ゴールドの初期化と表示
    GoldBoard = [[GoldBoardClass alloc]init:0 x_init:0 y_init:50 ketasu:10 type:@"gold"];
    [self displayScore:GoldBoard];
    
    size_machine = 100;
    
    
    count = 0;
    
    
    //パワーゲージの描画:新機種のframeサイズに応じて変える
    int devide_frame = 3;
    x_pg = rect_frame.size.width * (devide_frame - 1)/devide_frame;//左側１／４
    y_pg = rect_frame.size.height * (devide_frame - 1)/devide_frame;//下側１／４
    width_pg = MIN(x_pg / devide_frame, y_pg /devide_frame);
    height_pg = MIN(x_pg / devide_frame, y_pg /devide_frame);
    
    powerGauge = [[PowerGaugeClass alloc ]init:0 x_init:x_pg y_init:y_pg width:width_pg height:height_pg];
//    [powerGauge getImageView].transform = CGAffineTransformMakeRotation(2*M_PI* (float)(count-1)/60.0f );
    [self.view addSubview:[powerGauge getImageView]];
    
    //背景
    iv_powerGauge = [[UIImageView alloc]initWithFrame:CGRectMake(x_pg, y_pg, width_pg, height_pg)];//256bitx256bit
    iv_powerGauge.image = [UIImage imageNamed:@"powerGauge2.png"];
    iv_powerGauge.alpha = 0.1;
    [self.view addSubview:iv_powerGauge];


    iv_pg_ribrary = [[UIImageView alloc]initWithFrame:CGRectMake(x_pg, y_pg, width_pg, height_pg)];
    iv_pg_ribrary.image = [UIImage imageNamed:@"ribrary.png"];
    [self.view addSubview:iv_pg_ribrary];
    
    iv_pg_circle = [[UIImageView alloc]initWithFrame:CGRectMake(x_pg, y_pg, width_pg, height_pg)];
    iv_pg_circle.image = [UIImage imageNamed:@"circle_2w_rSmall_128.png"];
    [self.view addSubview:iv_pg_circle];

    
    iv_pg_cross = [[UIImageView alloc]initWithFrame:CGRectMake(x_pg, y_pg, width_pg, height_pg)];
    iv_pg_cross.image = [UIImage imageNamed:@"cross.png"];
    [self.view addSubview:iv_pg_cross];
    
    
    //一時停止ボタン
    int size_pause = 70;
    CGRect rect_pause = CGRectMake(rect_frame.size.width / 2 - size_pause / 2,30 , size_pause, size_pause);
//    UIImageView *iv_pause = [[UIImageView alloc]initWithFrame:CGRectMake(rect_frame.size.width / 2 - size_pause / 2,0 , size_pause, size_pause)];
    UIImageView *iv_pause = [CreateComponentClass createImageView:rect_pause image:@"close.png" tag:0 target:self selector:@"onClickedStopButton"];
    [iv_frame bringSubviewToFront:iv_pause];//iv_frameの上にボタン配置
    [iv_frame addSubview:iv_pause];

    
    //以下実行後、0.1秒間隔でtimerメソッドが呼び出されるが、それと並行してこのメソッド(viewDidLoad)も実行される(マルチスレッドのような感じ)
    tm = [NSTimer scheduledTimerWithTimeInterval:0.1
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];
}

- (void)ordinaryAnimationStart{
    //ユーザーインターフェース
    [self.view bringSubviewToFront:iv_frame];
    
    //消去、生成、更新、表示
    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/前時刻の描画を消去_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    for(int i = 0;i < [EnemyArray count] ; i++){
        [[(EnemyClass *)[EnemyArray objectAtIndex:i] getImageView ] removeFromSuperview];
    }
    
//    for(int i = 0; i < [BeamArray count] ;i++){
//        
//        [[(BeamClass *)[BeamArray objectAtIndex:i]getImageView] removeFromSuperview];
//    }
    for(int i = 0; i < [MyMachine getBeamCount]; i++){
        [[[MyMachine getBeam:i] getImageView] removeFromSuperview];
    }
    
    [[MyMachine getImageView] removeFromSuperview];
    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/生成_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//    if([EnemyArray count] < 10){
        [self yieldEnemy];
//    }

    if([MyMachine getIsAlive] && isTouched){
        [MyMachine yieldBeam:0 init_x:[MyMachine getX] init_y:[MyMachine getY]];
    }

    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/進行_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    
    if([MyMachine getIsAlive] ||
       [MyMachine getDeadTime] < explosionCycle){
        
        [MyMachine doNext];//設定されたtype、x_loc,y_locプロパティでUIImageViewを作成する
        
        //ダメージパーティクルの消去
        [[MyMachine getDamageParticle] setIsEmitting:NO];
        
        //ダメージを受けたときのイフェクト(画面を揺らす)
        
        
        
        
        //爆発から所定時間が経過しているか判定＝＞爆発パーティクルの消去
        if([MyMachine getDeadTime] >= explosionCycle){
            NSLog(@"mymachine : set emitting no");
            [[MyMachine getExplodeParticle] setIsEmitting:NO];//消去するには数秒後にNOに
            
            isGameMode = false;
            [self exitProcess];///////////////////////
            return;
        }
    }
    
    //敵機進行or爆発後のカウント
    for(int i = 0; i < [EnemyArray count] ; i++){
//        NSLog(@"do next at enemy:No %d", i);
        //既存敵機の距離進行！
        //dead状態になってからも、dead_timeが10未満の時までは更新doNextする(爆発パーティクル表示のため)
        if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive] ||
           [(EnemyClass *)[EnemyArray objectAtIndex:i] getDeadTime] < explosionCycle){
            
            //更新(進行位置の更新と爆発後の時間経過)
            [(EnemyClass *)[EnemyArray objectAtIndex:i] doNext];
//            NSLog(@"%d番目敵：y=%d", i, [(EnemyClass *)[EnemyArray objectAtIndex:i] getY]);
            
            //ダメージパーティクルの消去
            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle] setIsEmitting:NO];//消去するには数秒後にNOに
            
            //爆発してから時間が所定時間が経過してる場合
            if([(EnemyClass *)[EnemyArray objectAtIndex: i] getDeadTime] >= explosionCycle){
                //爆発パーティクルの消去
//                NSLog(@"パーティクル消去 at %d", i);
                [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setIsEmitting:NO];//消去するには数秒後にNOに

            }
        }
    }
    
    //ビーム進行=>出来ればMyMachineの保有オブジェクトにする
//    for(int i = 0; i < [BeamArray count] ; i++){
//        if([(BeamClass *)[BeamArray objectAtIndex:i] getIsAlive]) {
//            [(BeamClass *)[BeamArray objectAtIndex:i ] doNext];
//        }
//    }
    
    for(int i = 0; i < [MyMachine getBeamCount];i++){
        if([[MyMachine getBeam:i] getIsAlive]){
            [[MyMachine getBeam:i] doNext];
        }
    }


//    NSLog(@"敵機配列");
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/表示_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    for(int i = 0; i < [EnemyArray count] ; i++){
        if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive]){
            //ビューにメインイメージを貼り付ける
            [self.view addSubview:[(EnemyClass *)[EnemyArray objectAtIndex:i] getImageView]];
            
        }
    }
    
    if([MyMachine getIsAlive]){
        [MyMachine setType:(int)(count * 10) % 7];
        [self.view addSubview:[MyMachine getImageView]];
    }
    
    
//    for(int i = 0; i < [BeamArray count] ; i++){
//        if([(BeamClass *)[BeamArray objectAtIndex:i] getIsAlive]){
//            //ビューにメインイメージを貼り付ける
//            [self.view addSubview:[(BeamClass *)[BeamArray objectAtIndex:i] getImageView]];
//        }
//    }
    for(int i = 0 ; i < [MyMachine getBeamCount]; i++){
        if([[MyMachine getBeam:i]getIsAlive]){
            //ビューに自機イメージを貼り付ける
            [self.view addSubview:[[MyMachine getBeam:i] getImageView]];
        }
    }
    
    
    
    //アイテム取得判定
    for(int itemCount = 0; itemCount < [ItemArray count] ; itemCount++){
        ItemClass *_item = [ItemArray objectAtIndex:itemCount];
        if([_item getIsAlive]){//アイテムの獲得判定
            int _xItem = [_item getX];
            int _yItem = [_item getY];
                        
            if(
               _xItem >= [MyMachine getX] - [MyMachine getSize] / 2 &&
               _xItem <= [MyMachine getX] + [MyMachine getSize] / 2 &&
               _yItem >= [MyMachine getY] - [MyMachine getSize] / 2&&
               _yItem <= [MyMachine getY] + [MyMachine getSize] / 2){
                
                [[[ItemArray objectAtIndex:itemCount] getImageView] removeFromSuperview];
                [[ItemArray objectAtIndex:itemCount] die];
                
                /*
                 _/_/_/_/_/_/_/_/_/_/_/_/
                 得点を加算
                 武器を強化
                 シールドを強化
                 体力回復？？
                 _/_/_/_/_/_/_/_/_/_/_/_/
                 */
                
                
                
                //ゴールドを加算if item == gold
                [GoldBoard setScore:[GoldBoard getScore] + 1];
                [self displayScore:GoldBoard];
            }
        }
    }
    
    
    
    //敵機の衝突判定:against自機＆ビーム
    for(int i = 0; i < [EnemyArray count] ;i++ ) {//全ての生存している敵に対して
//        NSLog(@"敵衝突判定:%d", i);
        
        if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive]){//計算時間節約
            //                NSLog(@"敵衝突生存確認完了");
            
            EnemyClass *_enemy = (EnemyClass *)[EnemyArray objectAtIndex:i];
            
            //自機と敵機の衝突判定
            if(
               [MyMachine getX] >= [_enemy getX] - [_enemy getSize] * 0.6 &&
               [MyMachine getX] <= [_enemy getX] + [_enemy getSize] * 0.6 &&
               [_enemy getY] - [_enemy getSize] * 0 <= [MyMachine getY] &&
               [_enemy getY] + [_enemy getSize] * 0.5 >= [MyMachine getY]){
                
                NSLog(@"自機と敵機との衝突");
                //ダメージの設定
                [MyMachine setDamage:10 location:CGPointMake([MyMachine getX] + [MyMachine getSize]/2,[MyMachine getY] + [MyMachine getSize]/2)];
                //ヒットポイントのセット
                [powerGauge setValue:[MyMachine getHitPoint]];
                //パワーゲージの減少
                [self.view addSubview:[powerGauge getImageView]];
                
                
                
                //ダメージパーティクル表示
                [[MyMachine getDamageParticle] setUserInteractionEnabled: NO];//インタラクション拒否
                [[MyMachine getDamageParticle] setIsEmitting:YES];//消去するには数秒後にNOに
                [self.view bringSubviewToFront: [MyMachine getDamageParticle]];//最前面に
                [self.view addSubview: [MyMachine getDamageParticle]];//表示する
                
                
                //爆発パーティクル(ダメージ前isAliveがtrueからダメージ後falseになった場合は攻撃によって死んだ物として爆発)
                if(![MyMachine getIsAlive]){
                    
                    /*
                     修正点：爆発でスコアが見えなくなってしまっているので、爆発はスコアの背面にする(スコアが最前面にする？）
                     */
                    
//                    NSLog(@"パーティクル = %@", [MyMachine getExplodeParticle]);
                    [[MyMachine getExplodeParticle] setUserInteractionEnabled: NO];//インタラクション拒否
                    [[MyMachine getExplodeParticle] setIsEmitting:YES];//消去するには数秒後にNOに
                    [self.view bringSubviewToFront: [MyMachine getExplodeParticle]];//最前面に
                    [self.view addSubview: [MyMachine getExplodeParticle]];//表示する
                }
            }
            
            
            //敵機とビームの衝突判定
//            for(int j = 0; j < [BeamArray count] ;j++){//発射した全てのビームに対して
            BeamClass *_beam;
            for(int j = 0 ; j < [MyMachine getBeamCount];j++){
                _beam = [MyMachine getBeam:j];
                //                    NSLog(@"ビーム衝突判定:%d", j);
                if([_beam getIsAlive]){
                    //                        NSLog(@"ビーム発射確認完了");
                    
                    //左上位置
                    int _xBeam = [_beam getX];
                    int _yBeam = [_beam getY];
                    int _sBeam = [_beam getSize];
                    
                    //敵機とビームの衝突判定
                    if(
                       _xBeam >= [_enemy getX] - [_enemy getSize] * 0.3 &&
                       _xBeam <= [_enemy getX] + [_enemy getSize] * 1.3 &&
                       [_enemy getY] - [_enemy getSize] * 0 <= _yBeam &&
                       [_enemy getY] + [_enemy getSize] * 1>= _yBeam){
                        
                        
                        
                        NSLog(@"hit!!");
//                        NSLog(@"beam location[x = %d, y = %d], enemy location[x = %d, y = %d]",
//                              _xBeam, _yBeam, [_enemy getX], [_enemy getY]);
                        
                        //            bl_enemyAlive = false;
                        int damage = [_beam getPower];
                        
                        //ダメージ負荷時に切り替える
                        [[EnemyArray objectAtIndex:i] setIsDamaged:true];
                        
                        [(EnemyClass *)[EnemyArray objectAtIndex:i] setDamage:damage location:CGPointMake(_xBeam + _sBeam/2, _yBeam + _sBeam/2)];
                        
                        //上記setDamageでdieメソッドも包含実行
                        //                        [(EnemyClass *)[EnemyArray objectAtIndex:i] die:CGPointMake(_xBeam, _yBeam)];
                        
                        //                            [self drawBomb:(CGPointMake((float)_xBeam, (float)_yBeam))];

                        
                        //ダメージパーティクル表示
                        [[(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle] setUserInteractionEnabled: NO];//インタラクション拒否
                        
                        [[(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle] setIsEmitting:YES];//消去するには数秒後にNOに
                        
                        [self.view bringSubviewToFront: [(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle]];//最前面に
                        
                        [self.view addSubview: [(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle]];//表示する
                        
                        
                        
                        //爆発パーティクル
//                        NSLog(@"パーティクル = %@", [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]);
                        [[MyMachine getBeam:j] die];//衝突したらビームは消去
                        
                        
                        //敵を倒したら
                        if(![[EnemyArray objectAtIndex:i] getIsAlive]){
                            
                            //効果音=>別クラスに格納してstatic method化して簡潔に！
                            CFBundleRef mainBundle;
                            mainBundle = CFBundleGetMainBundle ();
                            soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("flinging"),CFSTR ("mp3"),NULL);
                            AudioServicesCreateSystemSoundID (soundURL, &soundID);
                            CFRelease (soundURL);
                            AudioServicesPlaySystemSound (soundID);
                            
//                            NSLog(@"パーティクル = %@", [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]);
                            //爆発パーティクル表示
                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setUserInteractionEnabled: NO];//インタラクション拒否
                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setIsEmitting:YES];//消去するには数秒後にNOに
                            [self.view bringSubviewToFront: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//最前面に
                            [self.view addSubview: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//表示する
                            
                            //得点の加算
                            [ScoreBoard setScore:[ScoreBoard getScore] + 5];//+1でよい？！
                            [self displayScore:ScoreBoard];
                            
                            enemyDown++;
                            
                            
                            //アイテム出現
                            if(true){//arc4random() % 2 == 0){
                                NSLog(@"アイテム出現");
                                ItemClass *_item = [[ItemClass alloc] init:_xBeam y_init:_yBeam width:50 height:50];

//                                [ItemArray addObject:_item];
                                [ItemArray insertObject:_item atIndex:0];
                                if([ItemArray count] > 50){
                                    [ItemArray removeLastObject];
                                }
                                [self.view bringSubviewToFront:[[ItemArray objectAtIndex:0] getImageView]];
                                [self.view addSubview:[[ItemArray objectAtIndex:0] getImageView]];
                                
                                //重なった時に被らないように最前面に
//                                [self.view bringSubviewToFront: [[ItemArray objectAtIndex:([ItemArray count]-1)] getImageView]];
//                                [self.view addSubview:[[ItemArray objectAtIndex:([ItemArray count]-1)] getImageView]];
                                
                                
                            }else{
                                NSLog(@"アイテムなし");
                            }

                        }
                        
                        break;//ビームループ脱出
                    }
                }
            }
        }
    }
    
    
    
    //powergaugeを回転させる
    [powerGauge setAngle:2*M_PI * count * 2/60.0f];
    
    //pg背景をアニメ
    [iv_powerGauge removeFromSuperview];
    int temp = count * 10  + 1;
    
    //透過度を0.1, 0.2, ・・, 1.0, 0.9, 0.8, ・・循環する。
    iv_powerGauge.alpha = 0.1 * MAX((temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +//二桁目が偶数の場合
                                    ((((int)(temp/10)+1)*10-temp) *(((int)(temp/10)) % 2)//二桁目が奇数のとき
                                     ), 0.1);//0.1以上にする
//    NSLog(@"%f", 0.1 * (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +//二桁目が偶数の場合
//          ((((int)(temp/10)+1)*10-temp) *((int)(temp/10) % 2)));//二桁目が奇数の場合
    [self.view addSubview:iv_powerGauge];
    
    iv_pg_ribrary.transform = CGAffineTransformMakeRotation(-2*M_PI * count * 2/60.0f);
    
    
    
//    NSLog(@"%d, %d, 偶数 = %d, 奇数 = %d, 10の位 = %d", temp, (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +
//          ((((int)(temp/10)+1)*10-temp) *(((int)(temp/10)) % 2)),
//          (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2),
//          (((((int)(temp/10)+1)+1)*10-temp) *((int)(temp/10) % 2)),
//          (int)(temp/10));
    
    
    
    
    //ユーザーインターフェース
    [self.view bringSubviewToFront:iv_frame];

}

//BGM曲をかける
-(void)playBGM{
    bgmClass = [[BGMClass alloc]init];
    switch (world_no) {
        case 0:
        {
            [bgmClass play:@"hisho_hmix"];
            break;
        }
        case 1:
        {
            [bgmClass play:@"bgm_game_687"];
            break;
        }
        case 2:
        {
            [bgmClass play:@"ones_hmix"];
            break;
        }
        case 3:
        {
            [bgmClass play:@"hisho_hmix"];
            break;
        }
        case 4:
        {
            [bgmClass play:@"kinpaku_hmix"];
            break;
        }
        case 5:{
            
            [bgmClass play:@"sabaki_hmix"];
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *tmインスタンスによって一定時間呼び出されるメソッド
 *一定間隔呼び出しは[tm invalidate];によって停止される
 */
- (void)time:(NSTimer*)timer{
    if(isGameMode){
        [self drawBackground];
        [self ordinaryAnimationStart];
        
        //一定時間経過するとゲームオーバー
//        if(count >= TIMEOVER_SECOND || ![MyMachine getIsAlive]){
//            NSLog(@"gameover");
            //経過したらタイマー終了
//            [self performSelector:@selector(exitProcess) withObject:nil afterDelay:0.1];//自機爆破後、即座に終了させると違和感あるため少しdelay
//            [self exitProcess];//delayさせるとその間にprogressが進んでしまうので即座に表示
//        }
        count += 0.1;
        
        if(count >= TIMEOVER_SECOND){
            isGameMode = false;
        }
        
    }else{
        
        //[tm invalid]をしないでisGameMode=falseとなった時 ＝ 一時停止ボタンが押された時もしくはプレイヤー撃破時
        //停止中画面に移行(一時停止用UIImageViewの表示)
        
    }
}
//- (void)onLongPressedFrame:(UILongPressGestureRecognizer *)gr {
////    [self yieldBeam:0 init_x:(x_myMachine + size_machine/2) init_y:(y_myMachine - length_beam)];
//    NSLog(@"長押しがされました．");
////    isTouched = true;
//}

- (void)onFlickedFrame:(UIPanGestureRecognizer*)gr {
    CGPoint point = [gr translationInView:[MyMachine getImageView]];
    CGPoint movedPoint = CGPointMake([MyMachine getImageView].center.x + point.x,
                                     [MyMachine getImageView].center.y + point.y);
    [MyMachine setX:movedPoint.x];
    [MyMachine setY:movedPoint.y];
    [MyMachine getImageView].center = movedPoint;
    [gr setTranslation:CGPointZero inView:[MyMachine getImageView]];
    
    
    
//    CGPoint point = [gr translationInView:iv_frame];
//    CGPoint movedPoint = CGPointMake(iv_frame.center.x + point.x,
//                                     iv_frame.center.y + point.y);
//    [MyMachine setX:movedPoint.x];
//    [MyMachine setY:movedPoint.y];
//    iv_frame.center = movedPoint;
//    [gr setTranslation:CGPointZero inView:iv_frame];//ここでself.viewを指定するのではなく、myMachineをセットする
//    [[MyMachine getImageView] bringSubviewToFront:self.view];
    
    // 指が移動したとき、上下方向にビューをスライドさせる
    if (gr.state == UIGestureRecognizerStateChanged) {//移動中
        isTouched = true;
        //        NSLog(@"x = %d, y = %d", (int)[gr translationInView:self.view].x, (int)[gr translationInView:self.view].y);
    }
    // 指が離されたとき、ビューを元に位置に戻して、ラベルの文字列を変更する
    else if (gr.state == UIGestureRecognizerStateEnded) {//指を離した時
        isTouched = false;
    }

    
}

-(void) viewWillDisappear:(BOOL)animated {
    //navigationバーの戻るボタン押下時の呼び出しメソッド
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"pressed back button");
        [tm invalidate];
    }
    [super viewWillDisappear:animated];
}


/**敵発生
 *count(0.1sec)に応じて発生頻度を大きくする
 * 0- 5sec:2secに一回
 * 6-10sec:1secに一回
 *11-15sec:0.5secに一回
 *16-20sec:0.25secに一回
 *21-25sec:0.125secに一回=ほぼ毎回
 */
-(void) yieldEnemy{
    Boolean isYield = false;
    if(count < 5){
        if(arc4random() % 20 == 0){//20分の1
            isYield = true;
        }
    }else if(count < 20){
        if(arc4random() % 10 == 0){//10分の1
            isYield = true;
        }
    }else if(count < 30){
        if(arc4random() % 5 == 0){//5分の1
            isYield = true;
        }
    }else if(count < 40){
        if(arc4random() % 3 == 0){//2.5分の1=3分の1
            isYield = true;
        }
    }else if(count < 50){
        if(arc4random() % 2 == 0){//2分の1
            isYield = true;
        }
    }else{
        if(true){
            isYield = true;
        }
    }
    
    if(isYield){
        enemyCount ++;
        int x = arc4random() % ((int)self.view.bounds.size.width - OBJECT_SIZE);
        
        EnemyClass *enemy = [[EnemyClass alloc]init:x size:OBJECT_SIZE];
        
        [EnemyArray insertObject:enemy atIndex:0];
        if([EnemyArray count] > 30) {
            [EnemyArray removeLastObject];
        }
    }

//    if((int)(count * 10) % 5 ==0 && arc4random() % 2 == 0){
//    
////        NSLog(@"生成");
//        int x = arc4random() % ((int)self.view.bounds.size.width - OBJECT_SIZE);
//
//        EnemyClass *enemy = [[EnemyClass alloc]init:x size:OBJECT_SIZE];
//        
//        [EnemyArray insertObject:enemy atIndex:0];
//        if([EnemyArray count] > 30) {
//            [EnemyArray removeLastObject];
//        }
////        [EnemyArray addObject:enemy];//既に初期化済なので追加のみ
////        NSLog(@"敵機 新規生成, %d, %d", [enemy getY], (int)(count * 10));
//    }
}

//yieldBeamメソッドはMyMachine内に実装
//-(void)yieldBeam:(int)beam_type init_x:(int)x init_y:(int)y{
//    //
//    if([MyMachine getIsAlive] && isTouched){
//        BeamClass *beam = [[BeamClass alloc] init:x - size_machine/3 y_init:y + size_machine/2 width:50 height:50];
//        [BeamArray addObject:beam];
//    }
//    
//    
//}

-(void)drawBackground{
    //frameの大きさと背景の現在描画位置を決定
    //点数オブジェクトで描画
    
    int velocity = 5;
    if(count < 50){
        velocity = 10;
    }else if(count < 100){
        velocity = 20;
    }else if(count < 150){
        velocity = 30;
    }
//    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, y_background1,rect_frame.size.width,rect_frame.size.height + 5)];
//    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, y_background2,rect_frame.size.width,rect_frame.size.height + 5)];
    
    iv_background1.center = CGPointMake(iv_background1.center.x, iv_background1.center.y + velocity);
    iv_background2.center = CGPointMake(iv_background2.center.x, iv_background2.center.y + velocity);
    if(iv_background1.center.y > (float)rect_frame.size.height * 1.5f){
        iv_background1.center = CGPointMake(iv_background1.center.x, rect_frame.size.height * -0.5f - 10);
    }else if(iv_background2.center.y > (float)rect_frame.size.height * 1.5f){
        iv_background2.center = CGPointMake(iv_background2.center.x, rect_frame.size.height * -0.5f - 10);
        
    }
    
    
    switch(world_no){
        case 0:{
            //宇宙空間の描画方法
            iv_background1.image = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            iv_background2.image = [UIImage imageNamed:@"cosmos_star4_repair.png"];
            break;
        }
        case 1:{
            //南国バージョン
            iv_background1.image = [UIImage imageNamed:@"back_nangoku.png"];
            iv_background2.image = [UIImage imageNamed:@"back_nangoku.png"];

            break;
        }
        case 2:{
            //宇宙バージョン
            iv_background1.image = [UIImage imageNamed:@"back_univ.png"];
            iv_background2.image = [UIImage imageNamed:@"back_univ2.png"];

            break;
        }
        case 3:{
            
            //雪山バージョン
            iv_background1.image = [UIImage imageNamed:@"back_snow.png"];
            iv_background2.image = [UIImage imageNamed:@"back_snow.png"];

            break;
        }
        case 4:{
            //砂漠バージョン
            iv_background1.image = [UIImage imageNamed:@"back_desert.png"];
            iv_background2.image = [UIImage imageNamed:@"back_desert.png"];

            break;
        }
        case 5:{
            //森バージョン
            iv_background1.image = [UIImage imageNamed:@"back_forest.png"];
            iv_background2.image = [UIImage imageNamed:@"back_forest.png"];
            break;
        }
    }

    
    
    
    
    
//    iv_background1.alpha = 0.9;//透過率
//    iv_background2.alpha = 0.9;//透過率

    
    
//    [self.view addSubview:iv_background1];
//    [self.view addSubview:iv_background2];
    
    [self.view sendSubviewToBack:iv_background1];//最背面に表示
//    [self.view sendSubviewToBack:iv_background2];
    
//    x_frame = rect_frame.size.width;
//    y_frame = rect_frame.size.height;
}


-(void)exitProcess{
    
    //タイマー終了(死んだ時に周囲の敵やイフェクトが動いているようにするかどうか)
    [tm invalidate];
    
    //
    UIView *superView = [CreateComponentClass createViewNoFrame:self.view.bounds
                                                          color:[UIColor clearColor]
                                                            tag:0
                                                         target:nil
                                                       selector:nil];
    [self.view addSubview:superView];
    
    
    //ゲーム終了時に呼び出されるメソッド
    //終了報告イメージ？ダイアログ？表示
    //データ：attrclassで処理
    
    //ゲームオーバー表示
    //ScoreBoard
    //GoldBoard
    //敵機撃破率
    
    
    int go_component_width = 250;
    
    //全体のフレーム
    UIView *view_go = [CreateComponentClass createView];
    [self.view addSubview:view_go];
    [self.view bringSubviewToFront:view_go];
    
    //gameover_display:go_y=10
    //tv_score
    //pv_score
    //tv_gold
    //pv_gold
    //tv_complete
    //pv_complete
    
    //ゲームオーバー表示
//    int go_width = 250;
    int go_height = 50;
    int go_y = 10;//view_go上での相対位置
    CGRect rect_gameover = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                      go_y,
                                      go_component_width,
                                      go_height);
    [view_go addSubview:[CreateComponentClass createImageView:rect_gameover
                                                        image:@"gameover.png"]];
    
    
    
    //ScoreBoard
    int score_y = go_y + go_height + 5;
    CGRect rect_score = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                   score_y,
                                   go_component_width,
                                   go_height);
//    [view_go addSubview:[CreateComponentClass createImageView:rect_score image:@"close"]];
    UITextView *tv_score = [CreateComponentClass createTextView:rect_score text:@"score : 0"];
    [tv_score setBackgroundColor:[UIColor clearColor]];
    [view_go addSubview:tv_score];
    
    UIProgressView *pv_score = [[UIProgressView alloc]
                               initWithProgressViewStyle:UIProgressViewStyleBar];
    pv_score.frame = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                               score_y + go_height,
                               go_component_width,
                               10);
    pv_score.progressTintColor = [UIColor greenColor];
    [view_go addSubview:pv_score];
    
    //GoldBoard
    int gold_y = score_y + go_height + 5;
    CGRect rect_gold = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                   gold_y,
                                   go_component_width,
                                   go_height);
//    [view_go addSubview:[CreateComponentClass createImageView:rect_gold image:@"close"]];
    UITextView *tv_gold = [CreateComponentClass createTextView:rect_gold text:@"gold : 0"];
    [tv_gold setBackgroundColor:[UIColor clearColor]];
    [view_go addSubview:tv_gold];
    
    //goldのprogressviewは不要
//    UIProgressView *pv_gold = [[UIProgressView alloc]
//                           initWithProgressViewStyle:UIProgressViewStyleBar];
//    pv_gold.progressTintColor = [UIColor redColor];
//    pv_gold.frame = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
//                          gold_y + go_height,
//                          go_component_width,
//                          10);
//    [view_go addSubview:pv_gold];
    
    
    //撃破率
    int complete_y = gold_y + go_height + 5;
    CGRect rect_complete = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                  complete_y,
                                  go_component_width,
                                  go_height);
//    [view_go addSubview:[CreateComponentClass createImageView:rect_complete image:@"close"]];
    UITextView *tv_complete = [CreateComponentClass createTextView:rect_complete text:@"complete : 0"];
    [tv_complete setBackgroundColor:[UIColor clearColor]];
    [view_go addSubview:tv_complete];
    UIProgressView *pv_complete = [[UIProgressView alloc]
                               initWithProgressViewStyle:UIProgressViewStyleBar];
    pv_complete.progressTintColor = [UIColor blueColor];
    pv_complete.frame = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                               complete_y + go_height,
                               go_component_width,
                               10);
    
    [view_go addSubview:pv_complete];
    
    //ダイアログで成績を表示(未)してからゲーム画面閉じる
//    CreateComponentClass *createComponentClass = [[CreateComponentClass alloc]init];

    
    //ボタン配置=>下から算出
    CGRect rect_btn = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
                                    view_go.bounds.size.height - go_height - 10,
                                    go_component_width,
                                    go_height);
    UIButton *qbBtn = [CreateComponentClass createQBButton:ButtonTypeWithImage
                                                      rect:rect_btn
                                                     image:@"blue_item_yuri_big2.png"
                                                     title:@"exit"
                                                    target:self
                                                  selector:@"pushExit"];
    [view_go addSubview:qbBtn];
    
    
    
    //リアルタイムに動的に表示
//    int pvMax = 10000;
    
    //マルチスレッド
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    //score:expに獲得したスコアを表示(pvはmaxは次のレベルに必要な値)
    //gold: pvは過去の最高値を横軸最大値とした軸
    //complete:100%を横軸最大値
    //三つとも最大値に達したら初期化してゼロからスタート
    //加えるべき値を別途定義してそれぞれ(pv_score等)に加えていく
    //上限まで達したら再度ゼロにして足していく
    
    dispatch_async(globalQueue, ^{
        AttrClass *attr = [[AttrClass alloc]init];
        int level = [[attr getValueFromDevice:@"level"] intValue];
        int exp = [[attr getValueFromDevice:@"exp"] intValue];
        int expTilNextLevel = [attr getMaxExpAtTheLevel:level];
        
        
        float unit = (float)expTilNextLevel / 100.0f;//progressViewの100分割ユニット＝最初のレベルで固定
        int loopCount = (float)(exp + [ScoreBoard getScore])/unit;
//        int loopCount = (float)(exp + 1000)/unit;//テスト用
        int cntInit = (float)exp / unit;
        int pvScoreValue = cntInit;
        //スコア表示
        for(int cnt = cntInit; cnt < loopCount ;cnt++){//expTilNextLevelを100分割した時に獲得したスコアがそのユニットの何倍か
            //時間のかかる処理
            for(int i = 0; i < 50; i++){
                NSLog(@"level = %d, cnt = %d, unit = %f, cu = %f, MaxExpAtLevel = %d, pvScoreValue = %d", level, cnt, unit ,cnt*unit, [attr getMaxExpAtTheLevel:level],pvScoreValue);
            }
            
            
            //メインスレッドで途中結果表示
            dispatch_async(mainQueue, ^{
                
                tv_score.text = [NSString stringWithFormat:@"EXP : %d",(int)(cnt * unit)];
                pv_score.progress = (float)pvScoreValue / 100.0f;
            });
            
            if(pvScoreValue <= 100){
//            if(cnt * unit < [attr getMaxExpAtTheLevel:level]){
                pvScoreValue ++;
                
            }else{
                level++;
                expTilNextLevel = [attr getMaxExpAtTheLevel:level];
                pvScoreValue = 0;
            }
        }
        
//        int addComplete = 0;//敵を倒した割合
        for(int cnt = 0;cnt < 100;cnt++){
            //時間のかかる処理
            for(int i = 0; i < 10; i++){
                NSLog(@"cnt = %d, enemyCount = %d, enemyDown = %d", cnt, enemyCount, enemyDown);
            }
            
            
            //メインスレッドで途中結果表示
            dispatch_async(mainQueue, ^{
                
                tv_complete.text = [NSString stringWithFormat:@"complete : %d%%", cnt];
                pv_complete.progress = (float)cnt / 100.0f;
            });
            if(enemyCount == 0){
                break;
            }else if(cnt >= (float)enemyDown / (float)enemyCount * 100.0f){
                break;
            }
        }
    });
    
    
    
    
    return ;
    
}

-(void)pushExit{
    //終了ボタン押下時対応=>サーバー接続してゲーム回数を更新
    
    // インジケーター表示
    [self showActivityIndicator];
    //サーバー通信
    [self performSelector:@selector(sendRequestToServer) withObject:nil afterDelay:0.1];
    
    
    [self exit];
}
-(void)exit{
    //    [super viewWillDisappear:NO];//storyboard遷移からの場合
    
    //BGM stop
    [bgmClass stop];
    
    //ウィンドウ閉じる
    [self dismissViewControllerAnimated:NO completion:nil];//itemSelectVCのpresentViewControllerからの場合
    
}

-(void)onClickedStopButton{
    NSLog(@"clicked stop button");
    isGameMode = false;
    
    [self displayStoppedFrame];
}

-(void)onClickedSettingButton{
    NSLog(@"clicked setting button");
    isGameMode = false;
    [self displaySettingFrame];
}

-(void)displayStoppedFrame{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PAUSE"
                                                    message:@"再開するにはボタンを押して下さい"
                                                   delegate:self//デリゲートによりボタン反応はalertViewメソッドに委ねられる
                                          cancelButtonTitle:@"ゲームに戻る"
                                          otherButtonTitles:@"quit"
                            ,nil];
    [alert show];
    

}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            isGameMode = true;
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            NSLog(@"2");
            [self exitProcess];
            break;
    }
    
}

-(void)displaySettingFrame{
    
}

-(void)displayScore:(ScoreBoardClass *)_boardClass{
    //スコアボードの表示
    
    //デジタル表示用
    /*
    for(int i = 0; i < [[_boardClass getDigitalArray] count]; i++){
        //removeはなくても新しいbackgroundframeの上に表示されるので見た目上は必要ない
        //が、ないとメモリがどんどん増えていくと思う。
        [(UIImageView*)[[_boardClass getDigitalArray] objectAtIndex:i] removeFromSuperview];
        [self.view addSubview:[[_boardClass getDigitalArray] objectAtIndex:i]];
    }
    */
    
    //テキストビュー用
    [[_boardClass getTextView] removeFromSuperview];
    [self.view addSubview:[_boardClass getTextView]];
}

//以下参考：http://www.atmarkit.co.jp/fsmart/articles/ios_sensor05/02.html

// 画面に指を一本以上タッチしたときに実行されるメソッド
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = true;
//    NSLog(@"touches count : %d (touchesBegan:withEvent:)", [touches count]);
}

// 画面に触れている指が一本以上移動したときに実行されるメソッド
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = true;

    //以下の方法ではズレる：onFlickedFrame内で実装
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint point = [touch locationInView:self.view];
//    [MyMachine setX:point.x];
//    [MyMachine setY:point.y];
    
    
//    NSLog(@"touches count : %d (touchesMoved:withEvent:)", [touches count]);
}

// 指を一本以上画面から離したときに実行されるメソッド
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = false;
//    NSLog(@"touches count : %d (touchesEnded:withEvent:)", [touches count]);
}

// システムイベントがタッチイベントをキャンセルしたときに実行されるメソッド
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = false;
//    NSLog(@"touches count : %d (touchesCancelled:withEvent:)", [touches count]);
}



//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//_/_/_/_/_/_/_/_/終了時処理_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
//サーバーに登録するためにhttp通信
-(void)sendRequestToServer{
    DBAccessClass *dbac = [[DBAccessClass alloc]init];
    AttrClass *attr = [[AttrClass alloc]init];
    NSString *_id = [attr getIdFromDevice];
    
    
    
    
    //_/_/_/_/_/端末情報更新開始：得点とゴールドを端末に記録させる=>時間がある時にAttrClassに代行！！_/_/_/_/_/_/_/_/_/_/
    //前回最高得点を取得する
    NSUserDefaults* score_defaults =
    [NSUserDefaults standardUserDefaults];
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    int max_score = [score_defaults integerForKey:@"max_score"];
    NSLog(@"now score = %d, max_score = %d", [ScoreBoard getScore], max_score);
    //今回取得したスコアが前回までの最高得点を上回れば更新
    if([ScoreBoard getScore] > max_score){
        //update
        max_score = [ScoreBoard getScore];
        [score_defaults setInteger:max_score forKey:@"max_score"];
        NSLog(@"score update! => %d", [score_defaults integerForKey:@"max_score"]);
        
        //congrat!! view appear!effect!!
        
        
        
    }else{
        NSLog(@"not updating so be going ...");
    }
    
    //累積ゴールドを取得して累積計算
    NSUserDefaults* gold_defaults = [NSUserDefaults standardUserDefaults];
    int before_gold = [gold_defaults integerForKey:@"gold_score"];
    int after_gold = before_gold + [GoldBoard getScore];
    NSLog(@"now gold = %d, before_gold = %d, so after_gold = %d", [GoldBoard getScore], before_gold, after_gold);
    //    if([GoldBoard getScore] < before_gold){
    [gold_defaults setInteger:after_gold forKey:@"gold_score"];
    NSLog(@"gold update! => %d ... this comment is annouced regardless updating!", [score_defaults integerForKey:@"gold_score"]);
    //    }else{
    //        NSLog(@"be going ...");
    //    }
    
    
    //exp&levelをupdate
    int beforeExp = [[attr getValueFromDevice:@"exp"] intValue];
    int beforeLevel = [[attr getValueFromDevice:@"level"] intValue];
    [attr addExp:[ScoreBoard getScore]];//setValutToDevice@exp & setValueToDevice@levelを両方同時に実行
    //    [attr setValueToDevice:@"exp" strValue:[NSString stringWithFormat:@"%d", afterExp]];
    //    [attr setValueToDevice:@"level" strValue:[NSString stringWithFormat:@"%d", afterLevel]];
    int afterExp = [[attr getValueFromDevice:@"exp"] intValue];
    int afterLevel = [[attr getValueFromDevice:@"level"] intValue];
    NSLog(@"ゲーム前経験値%d, 今回獲得スコア%d => ゲーム後経験値%d", beforeExp, [ScoreBoard getScore], afterExp);
    NSLog(@"ゲーム前レベル%d　=> ゲーム後レベル%d", beforeLevel, afterLevel);

    
    //_/_/_/_/_/_/端末情報更新完了_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    
    //_/_/_/_/サーバ情報更新：id	name	score	gold	login	gamecnt	level	exp_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    //score(最高得点)更新：既に比較されて端末情報max_scoreに格納されている。
//  after_score = [[dbac getValueFromDB:_id column:@"score"] intValue];
    [dbac updateValueToDB:_id column:@"score" newVal:[NSString stringWithFormat:@"%d", max_score]];
    
    //gold更新：既に累積されて端末情報gold_scoreに格納されている。
    [dbac updateValueToDB:_id column:@"gold" newVal:[NSString stringWithFormat:@"%d", after_gold]];
    
    //login:更新せず
    
    //gameCntをupdate
    int gameCnt = [[dbac getValueFromDB:_id column:@"gameCnt"] intValue];
    gameCnt ++;
    //        [dbac updateValueToDB:_id column:@"login" value:[NSString stringWithFormat:@"%d", login ]];
    [dbac updateValueToDB:_id column:@"gameCnt" newVal:[NSString stringWithFormat:@"%d", gameCnt]];
    NSLog(@"gameCnt = %@回目", [dbac getValueFromDB:_id column:@"gameCnt"]);
    
    //level
    [dbac updateValueToDB:_id column:@"level" newVal:[NSString stringWithFormat:@"%d", afterLevel]];
    
    //exp
    [dbac updateValueToDB:_id column:@"exp" newVal:[NSString stringWithFormat:@"%d", afterExp]];
    
    
    //更新情報の確認id	name	score	gold	login	gamecnt	level	exp
    NSLog(@"id = %@, name = %@, score = %@, gold = %@, login = %@, gameCnt = %@, level = %@, exp = %@",
          [dbac getValueFromDB:_id column:@"id"],
          [dbac getValueFromDB:_id column:@"name"],
          [dbac getValueFromDB:_id column:@"score"],
          [dbac getValueFromDB:_id column:@"gold"],
          [dbac getValueFromDB:_id column:@"login"],
          [dbac getValueFromDB:_id column:@"gamecnt"],
          [dbac getValueFromDB:_id column:@"level"],
          [dbac getValueFromDB:_id column:@"exp"]
          );
    
    // インジケーター非表示(このメソッドを表示する際に表示済)
    [self hideActivityIndicator];
    
}

/*
 * インジケーター表示
 */
- (void)showActivityIndicator
{
    // Activity Indicator 表示
    _loadingView                 = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
    _loadingView.backgroundColor = [UIColor blackColor];
    _loadingView.alpha           = 0.5f;
    _indicator                   = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator setCenter:CGPointMake(_loadingView.bounds.size.width/2, _loadingView.bounds.size.height/2)];
    [_loadingView addSubview:_indicator];
    [self.navigationController.view addSubview:_loadingView];
    [_indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/*
 * インジケーター非表示
 */
- (void)hideActivityIndicator
{
    // Activity Indicator 非表示
    [_indicator stopAnimating];
    [_loadingView removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
