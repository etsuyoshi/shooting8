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


CGRect rect_frame, rect_myMachine, rect_enemyBeam, rect_beam_launch;
UIImageView *iv_frame, *iv_myMachine, *iv_enemyBeam, *iv_beam_launch, *iv_background1, *iv_background2;

UIView *_loadingView;
UIActivityIndicatorView *_indicator;

int world_no;


//NSMutableArray *iv_arr_tokuten;
int y_background1, y_background2;
const int explosionCycle = 3;//爆発時間
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
    iv_background1.image = [UIImage imageNamed:@"cosmos_star4.png"];
    [self.view addSubview:iv_background1];//初期状態ではまず１枚目を描画させる
    y_background1 = 0;
    y_background2 = -rect_frame.size.height;

    
    length_beam = 20;
    thick_beam = 5;
    
    //敵の発生時の格納箱初期化
    EnemyArray = [[NSMutableArray alloc]init];
    
    //自機定義
    MyMachine = [[MyMachineClass alloc] init:x_frame/2 size:70];
    
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
    CGRect rect_pause = CGRectMake(rect_frame.size.width / 2 - size_pause / 2,50 , size_pause, size_pause);
//    UIImageView *iv_pause = [[UIImageView alloc]initWithFrame:CGRectMake(rect_frame.size.width / 2 - size_pause / 2,0 , size_pause, size_pause)];
    UIImageView *iv_pause = [CreateComponentClass createImageView:rect_pause image:@"close.png" tag:0 target:self selector:@"onClickedStopButton"];
    [iv_pause bringSubviewToFront:self.view];
    [self.view addSubview:iv_pause];

    
    //以下実行後、0.1秒間隔でtimerメソッドが呼び出されるが、それと並行してこのメソッド(viewDidLoad)も実行される(マルチスレッドのような感じ)
    tm = [NSTimer scheduledTimerWithTimeInterval:0.1
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];
}

- (void)ordinaryAnimationStart{
    //ユーザーインターフェース
    [iv_frame bringSubviewToFront:self.view];
    
    
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
        
        //爆発から所定時間が経過しているか判定＝＞爆発パーティクルの消去
        if([MyMachine getDeadTime] >= explosionCycle){
            NSLog(@"set emitting no");
            [[MyMachine getExplodeParticle] setIsEmitting:NO];//消去するには数秒後にNOに
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
            //ビューにメインイメージを貼り付ける
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
                [powerGauge setValue:[MyMachine getHitPoint]];//仮で90とする
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
            for(int j = 0 ; j < [MyMachine getBeamCount];j++){
                BeamClass *_beam = [MyMachine getBeam:j];
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
                            
                            
                            //アイテム出現
                            if(true){//arc4random() % 2 == 0){
                                NSLog(@"アイテム出現");
                                ItemClass *_item = [[ItemClass alloc] init:_xBeam y_init:_yBeam width:50 height:50];
                                [ItemArray addObject:_item];
                                
                                [self.view bringSubviewToFront: [[ItemArray objectAtIndex:([ItemArray count]-1)] getImageView]];//最前面に
                                [self.view addSubview:[[ItemArray objectAtIndex:([ItemArray count]-1)] getImageView]];
                                
                                
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
    [iv_frame bringSubviewToFront:self.view];

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

//- (void) handlePanGesture:(UIPanGestureRecognizer*) sender {
//    UIPanGestureRecognizer* pan = (UIPanGestureRecognizer*) sender;
//    CGPoint location = [pan translationInView:self.view];
//    NSLog(@"pan x=%f, y=%f", location.x, location.y);
//}

- (void)time:(NSTimer*)timer{
    if(isGameMode){
        [self drawBackground];
        
        count += 0.1;
        
        
        //ここにあったdoNextをこのメソッドの敵機生成前に移行
//        NSLog(@"count");
        [self ordinaryAnimationStart];
        
        //一定時間経過するとゲームオーバー
        if(count >= TIMEOVER_SECOND || ![MyMachine getIsAlive]){
            NSLog(@"gameover");
            //経過したらタイマー終了
            [tm invalidate];
            [self exitProcess];
        }
        
    }else{
        
        //一時停止ボタンが押された：isGameMode=false
        
        
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


- (void)onFlickedFrame1:(UIPanGestureRecognizer*)gr {
//    isTouched = true;
//    NSLog(@"onFlickedFrame");
    //参考：http://ultra-prism.jp/2012/12/01/uigesturerecognizer-touch-handling-sample/2/
//    http://www.yoheim.net/blog.php?q=20120620
    //フリックで移動した距離を取得する
    CGPoint point = [gr translationInView:[MyMachine getImageView]];
    
    //anticipate
    //指の動きが速いと画面上で認識した位置と実際の指の位置が異なる可能性がある
    //変化量([MyMachine getX] - point.x)が大きいときは変化量に応じた距離を計算(推測)する。
    //ガウシアン関数にして、移動量が大きい場合に追加移動距離も大きくする
    //速度はpoint(タッチした時からのトータル累積)で計るのではなく、前時刻の移動距離を記憶させる(その場合はタッチし始めを別途処理する必要がある。
    

//    CGPoint anticipatedPoint = CGPointMake(
//                                           [MyMachine getX] + point.x
//                                            + ((float)(point.x>10.0f)?15:0),
//                                           [MyMachine getY] + point.y
//                                            + ((float)(point.y>10.0f)?15:0));
////                                            + (int)(point.y*0.1) * 1.5);
////    [NSNumber numberWithInt:isEmitting?100:0]
//    NSLog(@"x = %f, point.x = %f", anticipatedPoint.x, point.x);
//    NSLog(@"y = %f, point.y = %f", anticipatedPoint.y, point.y);
//    [MyMachine setX:anticipatedPoint.x];
//    [MyMachine setY:anticipatedPoint.y];
    
    
    
    
    CGPoint movedPoint = CGPointMake([MyMachine getX] + point.x, [MyMachine getY] + point.y);
    
    [MyMachine setX:movedPoint.x];
    [MyMachine setY:movedPoint.y];
    [gr setTranslation:CGPointZero inView:[MyMachine getImageView]];//ここでself.viewを指定するのではなく、myMachineをセットする
    
    
    //以下を参考にパンジェスチャーをリアルタイムに認識しながら、MyMachineをbringToFrontするように描画する方法
    //    https://www.google.co.jp/search?q=uipangesturerecognizer+%E3%81%9A%E3%82%8C%E3%82%8B&oq=uipangesturerecognizer+%E3%81%9A%E3%82%8C%E3%82%8B&aqs=chrome..69i57.12622j0j7&sourceid=chrome&espv=210&es_sm=119&ie=UTF-8#es_sm=119&espv=210&q=uipangesturerecognizer+%E3%80%80%E7%B5%B6%E5%AF%BE%E4%BD%8D%E7%BD%AE%E3%82%92%E5%8F%96%E5%BE%97%E3%81%99%E3%82%8B
    //参考http://www.nekotricolor.com/blog/2012/08/10/414/
    //タップしたときの座標が画面全体の絶対的な座標でなく、画像内の相対的な座標になります。
//    CGPoint location = [gr translationInView:[MyMachine getImageView]];
//    CGPoint movedPoint = CGPointMake([MyMachine getImageView].center.x +location.x,
//                                     [MyMachine getImageView].center.y + location.y);
//    [MyMachine getImageView].center = movedPoint;
//    [MyMachine setLocation:movedPoint];
//    //    [MyMachine setX:anticipatedPoint.x];
//    //    [MyMachine setY:anticipatedPoint.y];
//    [gr setTranslation:CGPointZero inView:[MyMachine getImageView]];
    
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

-(void) yieldEnemy{
    //敵発生
//    NSLog(@"count = %d", [EnemyArray count]);
//    NSLog(@"%d", arc4random());
//    if(count == 0 || arc4random() % 4 == 0){
//    if(count == 0.5){
    if((int)(count * 10) % 5 ==0 && arc4random() % 2 == 0){
    
//        NSLog(@"生成");
        int x = arc4random() % 250;

        EnemyClass *enemy = [[EnemyClass alloc]init:x size:70];
        [EnemyArray addObject:enemy];//既に初期化済なので追加のみ
//        NSLog(@"敵機 新規生成, %d, %d", [enemy getY], (int)(count * 10));
    }


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
//    NSLog(@"drawbackground : 1 = %d, 2 = %d", y_background1, y_background2);
    y_background1 += 5;
    y_background2 += 5;//スクロール速度
    
    
    if(y_background1 > rect_frame.size.height){
        y_background1 = -rect_frame.size.height;
    }else if(y_background2 > rect_frame.size.height){
        y_background2 = -rect_frame.size.height;
    }
    
    
    [iv_background1 removeFromSuperview];
    [iv_background2 removeFromSuperview];
    iv_background1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, y_background1,rect_frame.size.width,rect_frame.size.height + 5)];
    iv_background2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, y_background2,rect_frame.size.width,rect_frame.size.height + 5)];
    
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

    
    
    [self.view addSubview:iv_background1];
    [self.view addSubview:iv_background2];
    
    [self.view sendSubviewToBack:iv_background1];//最背面に表示
    [self.view sendSubviewToBack:iv_background2];
    
//    x_frame = rect_frame.size.width;
//    y_frame = rect_frame.size.height;
}


-(void)exitProcess{

    //ゲーム終了時に呼び出されるメソッド
    //終了報告イメージ？ダイアログ？表示
    //データ：attrclassで処理
    
    
    
    //ゲームオーバー表示
    int go_width = 250;
    int go_height = 100;
    CGRect rect_gameover = CGRectMake(rect_frame.size.width/2 - go_width/2, 60, go_width, go_height);
    [self.view addSubview:[CreateComponentClass createView:rect_gameover]];
    [self.view addSubview:[CreateComponentClass createImageView:rect_gameover
                                                          image:@"gameover.png"]];
    
    
    
    //ダイアログで成績を表示(未)してからゲーム画面閉じる
//    CreateComponentClass *createComponentClass = [[CreateComponentClass alloc]init];
    [self.view addSubview:[CreateComponentClass createView]];
    
    //ボタン配置
    UIButton *qbBtn = [CreateComponentClass createQBButton:ButtonTypeWithImage
                                                      rect:CGRectMake(100, 200, 100, 60)
                                                     image:@"blue_item_yuri_big2.png"
                                                     title:@"exit"
                                                    target:self
                                                  selector:@"pushExit"];
    [self.view addSubview:qbBtn];
    
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
            [tm invalidate];
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
