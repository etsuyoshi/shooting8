//アイテム動線上のパーティクル表示
//アイテム取得時のエフェクト
/*
 ・m:viewMyEffectにのせる系
 ・m-:MyMachine getImageViewに変更
 ・o:周りに影響する系
 ->各アイテムに対応するpowerGauge2.pngを用意する必要あり
 
 mスイープ:周りから円半径変更：一定時間ずっと(イメージは後で追加:setbackground)
 m武器、防具取得：powerGauge2(色はわけた方が良い)
    武器：beamのiv.imageフィールド変更
    防具：viewMyEffectにanimated-Viewを追加
 mコイン取得時：kira.png->小さいものを4つ
 o爆発時対応:for([EnemyArray count])die
 m回復；kiraを複数animate
 m-拡大、縮小[MyMachine setSize:xxx];
 m-透明：[[MyMachine getimageview] setAlpha:0.3f]
 ・
 */

//line等のソーシャルプラットフォームがないため、PCエミュレータ上ではプロンプト上に警告が表示される(端末では問題ないので無視)
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
 ・ビームは単体で削除表示を繰り返す：対象物への接触判定がサンプリング間隔以内で行えないので、単体で進ませていく

 ・敵機をもっと頑丈に(typeによって爆発hit数を変更する):済
 ・自機からのビームはタップ時常時発射:済
 ・自機の移動はpanGesture:済
 */

//#define TEST
#define FREQ_ENEMY 10//100カウントに一回発生

#import "GameClassViewController.h"
#import "BGMClass.h"
#import "DBAccessClass.h"
#import "AttrClass.h"
#import "CreateComponentClass.h"
#import "EnemyClass.h"
#import "ItemClass.h"
#import "PowerGaugeClass.h"
#import "MyMachineClass.h"
#import "BackGroundClass.h"
#import "ScoreBoardClass.h"
#import "GoldBoardClass.h"
#import "UIView+Animation.h"
#import "Effect.h"
#import <QuartzCore/QuartzCore.h>
#define TIMEOVER_SECOND 1000
#define OBJECT_SIZE 70//自機と敵機のサイズ

CGRect rect_frame, rect_myMachine, rect_enemyBeam, rect_beam_launch;
UIImageView *iv_frame, *iv_myMachine, *iv_enemyBeam, *iv_beam_launch;//, *iv_background1, *iv_background2;

UIView *_loadingView;
UIActivityIndicatorView *_indicator;

#ifdef TEST
UITextView *tvCount;//テスト用
#endif

int world_no;


//NSMutableArray *iv_arr_tokuten;
int y_background1, y_background2;
const int explosionCycle = 30;//爆発時間
int max_enemy_in_frame;
int x_frame, y_frame;
//int x_myMachine, x_enemyMachine, x_beam;
//int y_myMachine, y_enemyMachine, y_beam;
int size_machine;
int length_beam, thick_beam;//ビームの長さと太さ
Boolean isGameMode;
Boolean flagItemTrigger;//エフェクト表示トリガー
Boolean isEffectDisplaying;//エフェクト表示中フラグ


UIPanGestureRecognizer *panGesture;
//UILongPressGestureRecognizer *longPress_frame;
Boolean isTouched;

BackGroundClass *BackGround;
MyMachineClass *MyMachine;
NSMutableArray *EnemyArray;
//NSMutableArray *BeamArray;
NSMutableArray *ItemArray;
//NSMutableArray *KiraArray;
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
float count = 0;//timer
int countItem = 0;//テスト用

//ordinaryMethod内部で使用するテンポラリー変数
ItemClass *_item;
ItemType itemType;
EnemyClass *_enemy;
BeamClass *_beam;//
int _xEnemy;
int _yEnemy;
int _sEnemy;
int _xItem;
int _yItem;
int _sItem;
int _xBeam;
int _yBeam;
int _sBeam;

UIView *viewMyEffect;


@interface GameClassViewController ()

@end




@implementation GameClassViewController

@synthesize sound_hit_URL;
@synthesize sound_hit_ID;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//ステータスバー非表示の一環
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    flagItemTrigger = false;
    
    //sound effect
    
    //ビームヒット音
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle ();
    sound_hit_URL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("flinging"),CFSTR ("mp3"),NULL);
    AudioServicesCreateSystemSoundID (sound_hit_URL, &sound_hit_ID);
    CFRelease (sound_hit_URL);
    
#ifdef TEST
    //テスト用
    tvCount = [CreateComponentClass createTextView:CGRectMake(0, 100, 100, 50)
                                              text:@"count:0"];

    [tvCount setBackgroundColor:[UIColor blackColor]];
    tvCount.textColor = [UIColor whiteColor];
    [self.view addSubview:tvCount];
#endif
    
    // ステータスバーを非表示にする
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        //ios7用
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6=>iOS 7ではきかない
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

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
    x_frame = rect_frame.size.width;
    y_frame = rect_frame.size.height;
    NSLog(@"frame-size : %d, %d", x_frame, y_frame);
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

    
    length_beam = 20;
    thick_beam = 5;
    
    //敵の発生時の格納箱初期化
    EnemyArray = [[NSMutableArray alloc]init];
    
    //背景インスタンス定義
    BackGround = [[BackGroundClass alloc]init:WorldTypeForest
                                        width:self.view.bounds.size.width
                                       height:self.view.bounds.size.height];
    
    
    [self.view addSubview:[BackGround getImageView1]];
    [self.view addSubview:[BackGround getImageView2]];
    
    
//    [(UIImageView *)[BackGround getImageView1] moveTo:CGPointMake(0, 400)
//                                             duration:200.0f
//                                               option:UIViewAnimationOptionCurveLinear];//一定速度
    
    //自機定義
    MyMachine = [[MyMachineClass alloc] init:x_frame/2 size:OBJECT_SIZE];
    [self.view addSubview:[MyMachine getImageView]];
    [self.view bringSubviewToFront:[MyMachine getImageView]];
    
    //自機エフェクトを描画するビュー
    viewMyEffect = [[UIView alloc] initWithFrame:[MyMachine getImageView].frame];
//    [viewMyEffect setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2f]];
    [self.view addSubview:viewMyEffect];
    [self.view bringSubviewToFront:viewMyEffect];
    
    //自機が発射したビームを格納する配列初期化=>MyMachineクラス内に実装
//    BeamArray = [[NSMutableArray alloc] init];
    
    //敵機を破壊した際のアイテム
    ItemArray = [[NSMutableArray alloc] init];
    
    //アイテム生成時、移動時、消滅時のパーティクル格納用配列
//    KiraArray = [[NSMutableArray alloc]init];
    
    
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
    int size_pause = 20;
    CGRect rect_pause = CGRectMake(rect_frame.size.width - size_pause,30 , size_pause, size_pause);
//    UIImageView *iv_pause = [[UIImageView alloc]initWithFrame:CGRectMake(rect_frame.size.width / 2 - size_pause / 2,0 , size_pause, size_pause)];
    UIImageView *iv_pause = [CreateComponentClass createImageView:rect_pause image:@"close.png" tag:0 target:self selector:@"onClickedStopButton"];
    [iv_frame bringSubviewToFront:iv_pause];//iv_frameの上にボタン配置
    [iv_frame addSubview:iv_pause];

    
    //以下実行後、0.1秒間隔でtimerメソッドが呼び出されるが、それと並行してこのメソッド(viewDidLoad)も実行される(マルチスレッドのような感じ)
    tm = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                          target:self
                                        selector:@selector(time:)//タイマー呼び出し
                                        userInfo:nil
                                         repeats:YES];
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


- (void)ordinaryAnimationStart{
    //ユーザーインターフェース
    [self.view bringSubviewToFront:iv_frame];
    
    //メモリ確認
//    NSLog(@"enemyArray length = %d", [EnemyArray count]);
//    NSLog(@"particleArray length = %d", [KiraArray count]);
    
    
    //消去、生成、更新、表示
    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/前時刻の描画を消去_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    /*旧形式の方法
    for(int i = 0; i < [MyMachine getBeamCount]; i++){
        [[[MyMachine getBeam:i] getImageView] removeFromSuperview];
    }
     */
    
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/生成_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    [self yieldEnemy];

    //ビーム生成はタッチ検出場所で実行
    if([MyMachine getIsAlive] && isTouched){
        [MyMachine yieldBeam:0 init_x:[MyMachine getX] init_y:[MyMachine getY]];
        //ビームはFIFOなので最初のもののみを表示
        [self.view addSubview:[[MyMachine getBeam:0] getImageView]];
    }
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/進行:各オブジェクトのdoNext_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    
    
    if([MyMachine getIsAlive] ||
       [MyMachine getDeadTime] < explosionCycle){
        
        
        [MyMachine doNext];//設定されたtype、x_loc,y_locプロパティでUIImageViewを作成する
        
        //ダメージを受けたときのイフェクト(画面を揺らす)=>縦方向に流れるアニメーション中なので難しい？
        
        
        
        
        //爆発から所定時間が経過しているか判定＝＞爆発パーティクルの消去
        if([MyMachine getDeadTime] >= explosionCycle){
            NSLog(@"mymachine : set emitting no");
            
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
            
            //爆発してから時間が所定時間が経過してる場合 or 画面外に移動した場合、削除
            if([(EnemyClass *)[EnemyArray objectAtIndex: i] getDeadTime] >= explosionCycle ||
               [[EnemyArray objectAtIndex:i] getY] >= self.view.bounds.size.height + OBJECT_SIZE){
                //爆発パーティクルの消去
#ifdef TEST
                NSLog(@"enemy remove at at %d", i);
#endif
                //explodeした場合は既に画面から消去されている
                [EnemyArray removeObjectAtIndex:i];
            }
        }
    }
    
    //自機ビームの進行
    //旧形式
    for(int i = 0; i < [MyMachine getBeamCount];i++){
        if([[MyMachine getBeam:i] getIsAlive]){
            [[MyMachine getBeam:i] doNext];
        }
    }
     
    
    //アイテムの進行=[アイテム自体の移動 & 生成したパーティクルの時間経過:寿命判定は別途]
    for(int i = 0 ; i< [ItemArray count]; i ++){
        if([[ItemArray objectAtIndex:i] getIsAlive]){
            if([(ItemClass *)[ItemArray objectAtIndex:i] doNext]){//移動とパーティクル発生判定：同時実行
//                NSLog(@"create particle");
                //動線上パーティクルの格納と表示
                [self.view addSubview:[[ItemArray objectAtIndex:i] getMovingParticle:0]] ;//生成したparticleは自動消滅
//                [KiraArray insertObject:[((ItemClass*)[ItemArray objectAtIndex:i]) getMovingParticle:0] atIndex:0];
//                [self.view addSubview:[KiraArray objectAtIndex:0]];
            };
        }
    }
    
//    NSLog(@"敵機配列");
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/表示_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    
    //アイテム取得判定：前倒しに取得させる
    for(int itemCount = 0; itemCount < [ItemArray count] ; itemCount++){
        _item = [ItemArray objectAtIndex:itemCount];
        if([_item getIsAlive]){//アイテムの獲得判定
            _xItem = [_item getX];
            _yItem = [_item getY];
            
//            NSLog(@"xI = %d, xM = %d, yI = %d, yM = %d",
//                  _xItem, [MyMachine getX],
//                  _yItem, [MyMachine getY]);
            if(
               _xItem >= [MyMachine getX] - OBJECT_SIZE * 0.5 &&
               _xItem <= [MyMachine getX] + OBJECT_SIZE * 0.5 &&
               _yItem >= [MyMachine getY] - OBJECT_SIZE * 0.5 &&
               _yItem <= [MyMachine getY] + OBJECT_SIZE * 0.5){
                
                flagItemTrigger = true;
                
                
//                NSLog(@"Item acquired");
                [[[ItemArray objectAtIndex:itemCount] getImageView] removeFromSuperview];
                [[ItemArray objectAtIndex:itemCount] die];
                //アイテム取得時のパーティクル表示
                [self.view addSubview:[[ItemArray objectAtIndex:itemCount] getKilledParticle]];
                
//                Effect *effect = [[Effect alloc]initWithFrame:[MyMachine getImageView].frame];
//                UIView *viewMagnetEffect = [effect getEffectView:EffectTypeStandard];
////                [viewMyEffect addSubview:viewMagnetEffect];
//                [self.view addSubview:viewMagnetEffect];
                
                //取得したアイテムを判定
                itemType = [_item getType];
//                NSLog(@"%d", itemType);
                switch ((ItemType)itemType) {
                    case ItemTypeYellowGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 1];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeGreenGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 2];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeBlueGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 3];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypePurpleGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 5];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeRedGold:{
                        [GoldBoard setScore:[GoldBoard getScore] + 10];
                        [self displayScore:GoldBoard];
                        break;
                    }
                    case ItemTypeMagnet:{
                        [MyMachine setStatus:@"StatusTlMagnet" key:@"1"];
                        break;
                    }
                    case ItemTypeBig:{
                        //bigger
                        [MyMachine setStatus:@"StatusTlBig" key:@"1"];
                        
                        break;
                    }
                    case ItemTypeBomb:{
                        [MyMachine setStatus:@"StatusTlBomb" key:@"1"];
                        break;
                    }
                    case ItemTypeDeffense0:{
                        [MyMachine setStatus:@"StatusTlBarrier" key:@"1"];
                        break;
                    }
                    case ItemTypeDeffense1:{
                        [MyMachine setStatus:@"StatusDfShield" key:@"1"];
                        break;
                    }
                    case ItemTypeHeal:{
                        [MyMachine setStatus:@"StatusTlHeal" key:@"1"];
                        break;
                    }
                    case ItemTypeSmall:{
                        [MyMachine setStatus:@"StatusTlSmall" key:@"1"];
                        break;
                    }
                    case ItemTypeTransparency:{
                        [MyMachine setStatus:@"StatusTlTransparancy" key:@"1"];
                        break;
                    }
                    case ItemTypeWeapon0:{//wpBomb
                        [MyMachine setStatus:@"StatusWpBomb" key:@"1"];
                        break;
                    }
                    case ItemTypeWeapon1:{//wpDiffuse
                        [MyMachine setStatus:@"StatusWpDiffuse" key:@"1"];
                        break;
                    }
                    case ItemTypeWeapon2:{//wpLaser
                        [MyMachine setStatus:@"StatusWpLaser" key:@"1"];
                        break;
                    }
                    default:
                        break;
                }

                /*
                 _/_/_/_/_/_/_/_/_/_/_/_/
                 得点を加算
                 武器を強化
                 シールドを強化
                 体力回復？？
                 _/_/_/_/_/_/_/_/_/_/_/_/
                 */
                
                //ゴールドを加算if item == gold
                
            }
        }
    }
    
    
    
    //敵機の衝突判定:against自機＆ビーム
    for(int i = [EnemyArray count] - 1; i >= 0 ;i-- ) {//全ての生存している敵に対して発生した順番に衝突判定
//        NSLog(@"敵衝突判定:%d", i);
        
        if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive]){//計算時間節約
            
            if([[EnemyArray objectAtIndex:i] getY] >= self.view.bounds.size.height){
                [[EnemyArray objectAtIndex:i] die];
                continue;
            }
            //                NSLog(@"敵衝突生存確認完了");
            
            _enemy = [EnemyArray objectAtIndex:i];
            _xEnemy = [_enemy getX];
            _yEnemy = [_enemy getY];
            _sEnemy = [_enemy getSize];
            
            //自機と敵機の衝突判定
            if(
               [MyMachine getX] >= _xEnemy - _sEnemy * 0.4 &&
               [MyMachine getX] <= _xEnemy + _sEnemy * 0.4 &&
               _yEnemy - _sEnemy * 0.4 <= [MyMachine getY] &&
               _yEnemy + _sEnemy * 0.4 >= [MyMachine getY]){
                
                NSLog(@"自機と敵機との衝突");
                //ダメージの設定
                [MyMachine setDamage:10 location:CGPointMake([MyMachine getX],[MyMachine getY])];
                //ヒットポイントのセット
//                [powerGauge setValue:[MyMachine getHitPoint]];
                //パワーゲージの減少
                [self.view addSubview:[powerGauge getImageView]];
                
                
                
                //ダメージパーティクル表示
                [[MyMachine getDamageParticle] setUserInteractionEnabled: NO];//インタラクション拒否
                [[MyMachine getDamageParticle] setIsEmitting:YES];//消去するには数秒後にNOに
                [self.view bringSubviewToFront: [MyMachine getDamageParticle]];//最前面に
                [self.view addSubview: [MyMachine getDamageParticle]];//表示する
                
                
                //爆発パーティクル(ダメージ前isAliveがtrueからダメージ後falseになった場合は攻撃によって死んだものとして爆発)
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
            for(int j = 0 ; j < [MyMachine getBeamCount];j++){
                _beam = [MyMachine getBeam:j];
                
                if([_beam getIsAlive]){
                    //左上位置
                    _xBeam = [_beam getX];
                    _yBeam = [_beam getY];
                    _sBeam = [_beam getSize];
                    
                    
                    //ビームは前方のみ進行するのでビーム位置より後方の敵は判定しないようにする必要
                    //敵の付番はfifo:0先30後
                    //若い番号の敵がビーム位置より後方ならば遅い番号の敵は判定しなくて良い
                    
                    //敵機とビームの衝突判定
                    //ビーム右端が敵左端より右側
                    //ビーム左端が敵右端より左側
                    //ビーム上端が敵上端より下側
                    //ビーム下端が敵下端より上側
                    if(
                       _xBeam + _sBeam * 0.5 >= _xEnemy - _sEnemy * 0.5 &&
                       _xBeam - _sBeam * 0.5 <= _xEnemy + _sEnemy * 0.5 &&
                       _yBeam - _sBeam * 0.5 >= _yEnemy - _sEnemy * 0.5 &&
                       _yBeam + _sBeam * 0.5 <= _yEnemy + _sEnemy * 0.5 ){
                        
                        
                        //レーザーでない場合
                        [[MyMachine getBeam:j] die];//衝突したらビームは消去
                        [[[MyMachine getBeam:j] getImageView] removeFromSuperview];//画面削除
                        
                        
                        //ビームが衝突した位置にdamageParticle表示(damageParticle生成のため位置情報を渡す)
                        [(EnemyClass *)[EnemyArray objectAtIndex:i] setDamage:[_beam getPower] location:CGPointMake(_xBeam, _yBeam)];
                        

                        
                        
                        //ビームに当たる前に生きていた敵が死んだら＝今回のビームで敵を倒したら
                        if(![[EnemyArray objectAtIndex:i] getIsAlive]){
                            
                            //imageViewだけを消去(爆発パーティクルが描画するためインスタンス自体は残しておく)
                            [[[EnemyArray objectAtIndex:i] getImageView] removeFromSuperview];
                            
                            
                            //効果音=>別クラスに格納してstatic method化して簡潔に！
                            AudioServicesPlaySystemSound (sound_hit_ID);

////                            NSLog(@"パーティクル = %@", [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]);
                            //爆発パーティクル表示
//                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setUserInteractionEnabled: NO];//インタラクション拒否
//                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle] setIsEmitting:YES];//消去するには数秒後にNOに
//                            [self.view bringSubviewToFront: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//最前面に
//                            [self.view addSubview: [(EnemyClass *)[EnemyArray objectAtIndex:i] getExplodeParticle]];//表示する
                            //smoke-effect
                            UIView *smoke = [[EnemyArray objectAtIndex:i] getSmokeEffect];
                            [self.view bringSubviewToFront:smoke];
                            [self.view addSubview:smoke];
                            smoke = [[EnemyArray objectAtIndex:i] getSmokeEffect];
                            [self.view bringSubviewToFront:smoke];
                            [self.view addSubview:smoke];
                            smoke = [[EnemyArray objectAtIndex:i] getSmokeEffect];
                            [self.view bringSubviewToFront:smoke];
                            [self.view addSubview:smoke];
//                            [self.view addSubview:[[EnemyArray objectAtIndex:i] getSmokeEffect]];
//                            [self.view addSubview:[[EnemyArray objectAtIndex:i] getSmokeEffect]];
                            
                            //メモリ解放
//                            [EnemyArray removeObjectAtIndex:i];
                            
                            //得点の加算
                            [ScoreBoard setScore:[ScoreBoard getScore] + 5];//+1でよい？！
                            [self displayScore:ScoreBoard];
                            
                            enemyDown++;
//                            NSLog(@"enemyDown: %d", enemyDown);
                            
                            //アイテム出現
                            if(true){//arc4random() % 2 == 0){
//                                NSLog(@"アイテム出現");
//                                ItemClass *_item = [[ItemClass alloc] init:[_enemy getX] y_init:[_enemy getY] width:50 height:50];
                                
                                //テスト：順番に作成
                                NSLog(@"item occur : %d", countItem);
                                _item = [[ItemClass alloc] init:(countItem++) % 15 x_init:_xEnemy y_init:_yEnemy width:50 height:50];

//                                [ItemArray addObject:_item];
                                [ItemArray insertObject:_item atIndex:0];
                                //現状全てのアイテムは手前に進んで消えるので先に発生(FIFO)したものから消去
                                if([ItemArray count] > 50){
                                    [ItemArray removeLastObject];
                                }
                                [self.view bringSubviewToFront:[[ItemArray objectAtIndex:0] getImageView]];
                                [self.view addSubview:[[ItemArray objectAtIndex:0] getImageView]];
                                
                                
                            }else{
                                NSLog(@"アイテムなし");
                            }
                            
                            
                            /*
                             【以下のbreakは極めて重要！】
                             強いビームパワーの場合、(一発で倒しても)同じ敵に対して何度もhit(＝enemyDown++)してしまう
                             １つの敵に対して複数の玉があたってenemyDownする
                             */
                            break;//その敵への衝突判定は辞めて、次の敵への衝突判定のため最初から最後までビームループを回す＃注意
                            //＃ちなみに(最初：最後に発生したビームから)「最後：最初に発生したビームまで」の衝突判定をさせるのたは「ある意味」非効率：今回ビームjより(時間的)前に発生したビームが後ろの敵に当たることはあまりない
                            //#しかし、自機がビームの進行速度を上回って前方に進行した場合や敵機がまっすぐ進行して来なかった場合(曲線を描いて来た場合など)は時間的に後で発生したビームに衝突する場合がある。
                            //前提：ビームも敵もFIFO配列

                        }else{
                            //敵が倒されなければダメージパーティクルのみ表示
                            //処理が重くなるので実施見送り
                            //ダメージパーティクル表示：処理が間に合わない可能性があるので、配列に格納して数カウントで消去
//                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle] setUserInteractionEnabled: NO];//インタラクション拒否
//                            [[(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle] setIsEmitting:YES];//消去するには数秒後にNOに
//                            [self.view bringSubviewToFront: [(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle]];//最前面に
//                            [self.view addSubview: [(EnemyClass *)[EnemyArray objectAtIndex:i] getDamageParticle]];//表示する:次のcountで消去
                            
                            
                            
                            //その敵が生きているならば同じ敵に別のビームへの衝突判定するため(continue)
                            continue;//次のビームの衝突判定へ(ビームループ内でこの後何もしなければこのcontinueはなくても良い)

                        }
                        
//                        break;//何の判定もせずににビーム[j]ループ脱出すると次以降のビームが敵に当たっている位置にいるのに衝突しないでスルーしてしまう
                        
                    }//ビーム衝突判定(位置判定)
                }//if(_beam isAlive)
            }//for(int j = 0 ; j < [MyMachine getBeamCount];j++)：ビームループ
        }else{//if([(EnemyClass *)[EnemyArray objectAtIndex:i] getIsAlive])
            [EnemyArray removeObjectAtIndex:i];
        }
    }//for(int i = 0; i < [EnemyArray count] ;i++ )：敵ループ
    
    
    
    //powergaugeを回転させる
//    [powerGauge setAngle:2*M_PI * count * 2/60.0f];
//    
//    //pg背景をアニメ
//    [iv_powerGauge removeFromSuperview];
//    int temp = count * 10  + 1;
//    
//    //透過度を0.1, 0.2, ・・, 1.0, 0.9, 0.8, ・・循環する。
//    iv_powerGauge.alpha = 0.1 * MAX((temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +//二桁目が偶数の場合
//                                    ((((int)(temp/10)+1)*10-temp) *(((int)(temp/10)) % 2)//二桁目が奇数のとき
//                                     ), 0.1);//0.1以上にする
////    NSLog(@"%f", 0.1 * (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +//二桁目が偶数の場合
////          ((((int)(temp/10)+1)*10-temp) *((int)(temp/10) % 2)));//二桁目が奇数の場合
//    [self.view addSubview:iv_powerGauge];
//    
//    iv_pg_ribrary.transform = CGAffineTransformMakeRotation(-2*M_PI * count * 2/60.0f);
    
    
    
//    NSLog(@"%d, %d, 偶数 = %d, 奇数 = %d, 10の位 = %d", temp, (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2) +
//          ((((int)(temp/10)+1)*10-temp) *(((int)(temp/10)) % 2)),
//          (temp - (int)(temp/10)*10)*((((int)(temp/10)) + 1) % 2),
//          (((((int)(temp/10)+1)+1)*10-temp) *((int)(temp/10) % 2)),
//          (int)(temp/10));
    
    
//    if((int)count % 10 == 0){
        [self garvageCollection];
//    }
    
    
    //ユーザーインターフェース
//    [self.view bringSubviewToFront:iv_frame];

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
    if(count == 0){
        [BackGround startAnimation:3.0f];//3sec-Round
    }
    if(isGameMode){
        [self ordinaryAnimationStart];
        
        //一定時間経過するとゲームオーバー
//        if(count >= TIMEOVER_SECOND || ![MyMachine getIsAlive]){
//            NSLog(@"gameover");
            //経過したらタイマー終了
//            [self performSelector:@selector(exitProcess) withObject:nil afterDelay:0.1];//自機爆破後、即座に終了させると違和感あるため少しdelay
//            [self exitProcess];//delayさせるとその間にprogressが進んでしまうので即座に表示
//        }
        count += 0.1f;
        
        if(count >= TIMEOVER_SECOND){
            isGameMode = false;
            [self exitProcess];//delayさせるとその間にprogressが進んでしまうので即座に表示
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

-(void)garvageCollection{
    for(int i = 0; i < [EnemyArray count]; i++){
//        NSLog(@"i = %d at Y = %d", i, [[EnemyArray objectAtIndex:i]getY]);
        if([[EnemyArray objectAtIndex:i] getY] >= self.view.bounds.size.height ||
           ![[EnemyArray objectAtIndex:i] getIsAlive]){
//            NSLog(@"remove at %d, %d", i, [[EnemyArray objectAtIndex:i] getY]);
            [EnemyArray removeObjectAtIndex:i];
        }
    }
    for(int i = 0; i < [ItemArray count]; i++){
        if([[ItemArray objectAtIndex:i] getY] >= self.view.bounds.size.height ||
           ![[ItemArray objectAtIndex:i] getIsAlive]){
            [ItemArray removeObjectAtIndex:i];
        }
    }
}
- (void)onFlickedFrame:(UIPanGestureRecognizer*)gr {
    CGPoint point = [gr translationInView:[MyMachine getImageView]];
    CGPoint movedPoint = CGPointMake([MyMachine getImageView].center.x + point.x,
                                     [MyMachine getImageView].center.y + point.y);
//    [MyMachine setX:movedPoint.x];
//    [MyMachine setY:movedPoint.y];
    [MyMachine setLocation:CGPointMake(movedPoint.x, movedPoint.y)];
    [MyMachine getImageView].center = movedPoint;
    [gr setTranslation:CGPointZero inView:[MyMachine getImageView]];
    
    
    viewMyEffect.center = movedPoint;
    [gr setTranslation:CGPointZero inView:viewMyEffect];
    
    
    
    // 指が移動したとき、上下方向にビューをスライドさせる
    if (gr.state == UIGestureRecognizerStateChanged) {//移動中
        isTouched = true;
    }
    // 指が離されたとき、ビューを元に位置に戻して、ラベルの文字列を変更する
    else if (gr.state == UIGestureRecognizerStateEnded) {//指を離した時
        isTouched = false;
    }
    
    //ビーム生成
    if([MyMachine getIsAlive] && isTouched){
        [MyMachine yieldBeam:0 init_x:[MyMachine getX] init_y:[MyMachine getY]];
        //ビームはFIFOなので最初のもののみを表示
        [self.view addSubview:[[MyMachine getBeam:0] getImageView]];
    }
    
    if(flagItemTrigger && !isEffectDisplaying){//他のエフェクトが表示中でなければ
        flagItemTrigger = false;
        isEffectDisplaying = true;
        
        
        int diameter = 100;
        int duration = 3;//repeat-count
        int finishRadius = 20;
        CGFloat animationDuration = 0.5f; // Your duration
        CGFloat animationDelay = 0; // Your delay (if any)
        UIImageView *circle = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30,
                                                                            diameter,
                                                                            diameter)];
        circle.center = CGPointMake(viewMyEffect.frame.size.width/2,
                                    viewMyEffect.frame.size.height/2);
        circle.layer.cornerRadius=diameter/2;
        
        //cyan[0,1,1]
        UIColor *itemColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1f];
        circle.layer.borderColor=[[itemColor colorWithAlphaComponent:0.75f] CGColor] ;
        circle.layer.borderWidth = 4.0f;//4px
        circle.layer.backgroundColor = [itemColor CGColor];

        
        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        [cornerRadiusAnimation setFromValue:[NSNumber numberWithFloat:diameter/2]]; // The current value
        [cornerRadiusAnimation setToValue:[NSNumber numberWithFloat:10.0]]; // The new value
        [cornerRadiusAnimation setDuration:animationDuration];
        [cornerRadiusAnimation setBeginTime:CACurrentMediaTime() + animationDelay];
        [cornerRadiusAnimation setRepeatCount:duration];
        
        // If your UIView animation uses a timing funcition then your basic animation needs the same one
        [cornerRadiusAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        // This will keep make the animation look as the "from" and "to" values before and after the animation
        [cornerRadiusAnimation setFillMode:kCAFillModeBoth];
        [circle.layer addAnimation:cornerRadiusAnimation forKey:@"keepAsCircle"];
//        [circle.layer setCornerRadius:10.0]; // Core Animation doesn't change the real value so we have to.
        
        [UIView animateWithDuration:animationDuration
                              delay:animationDelay
                            options:UIViewAnimationOptionCurveEaseInOut
         //                                |UIViewAnimationOptionRepeat
                         animations:^{
                             [UIView setAnimationRepeatCount: duration];
                             [circle.layer setFrame:CGRectMake(viewMyEffect.frame.size.width/2-finishRadius/2,
                                                               viewMyEffect.frame.size.height/2-finishRadius/2,
                                                               finishRadius,
                                                               finishRadius)]; // Arbitrary frame ...
                             [circle.layer setBackgroundColor:[[UIColor colorWithRed:0
                                                                               green:1
                                                                                blue:1
                                                                               alpha:0.5f] CGColor]];
                             circle.center = CGPointMake(viewMyEffect.frame.size.width/2,
                                                         viewMyEffect.frame.size.height/2);//viewEffect.center;//
                             // You other UIView animations in here...
                         } completion:^(BOOL finished) {
                             // Maybe you have your completion in here...
                             [circle removeFromSuperview];
                             isEffectDisplaying = false;
                             //                         [viewMyEffect removeFromSuperview];
                         }];
        
        [viewMyEffect addSubview:circle];
    
    }
    
    
    
//    NSLog(@"touched");

    
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
    
#ifndef TEST
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
#else
    //1秒にfreq*10回発生
    float freq = 0.1f;
    float error = 0.01f;//内部計算誤差
    //freq10:0.1, 0.2, 0.3
    //freq4 :0.25,0.50,0.75
    //freq3 :0.33,0.66,0.99
//    if(1.0f / freq == count){
    for(int i = 0;i < 100000;i++){
        if((1.0f / freq * (float)i >= count - error) &&
           (1.0f / freq * (float)i <= count + error)){
            isYield = true;
            break;
        }
    }
#endif
    if(arc4random() % FREQ_ENEMY == 0){
        isYield = true;
    }else{
        isYield = false;
    }
    if(isYield){
        enemyCount ++;
//        NSLog(@"enemyCount %d", enemyCount);
        int x = arc4random() % ((int)self.view.bounds.size.width - OBJECT_SIZE);
        
        EnemyClass *enemy = [[EnemyClass alloc]init:x size:OBJECT_SIZE];
        
        [EnemyArray insertObject:enemy atIndex:0];
        [self.view addSubview:[[EnemyArray objectAtIndex:0] getImageView]];
        [self.view bringSubviewToFront:[[EnemyArray objectAtIndex:0] getImageView]];
        
        
//#ifdef TEST
//      [[EnemyArray objectAtIndex:0] getImageView].center = CGPointMake(self.view.bounds.size.width / 2,
//                                                                       arc4random() % (int)self.view.bounds.size.height);
//#endif
        
//        [iv_background1 bringSubviewToFront:[[EnemyArray objectAtIndex:0] getImageView]];
//        [iv_background2 bringSubviewToFront:[[EnemyArray objectAtIndex:0] getImageView]];
        
        if([EnemyArray count] > 50) {
            [[[EnemyArray lastObject] getImageView] removeFromSuperview];
            //(パーティクルを生成していたら)パーティクルを消去
            [[[EnemyArray lastObject] getDamageParticle] removeFromSuperview];
            [[[EnemyArray lastObject] getExplodeParticle] removeFromSuperview];
            //配列から削除してメモリを解放
            [EnemyArray removeLastObject];
            
            //発生した中で古いものから画面外にあるenemyを消去
//            for(int i = [EnemyArray count] - 1; i > 0;i--){
//                if([[EnemyArray objectAtIndex:i] getImageView].center.y > self.view.bounds.size.height ||
//                   !([[EnemyArray objectAtIndex:i] getIsAlive])){
////                    NSLog(@"memory release at enemy %d", i);
//                    //画面から消去
//                    [[[EnemyArray objectAtIndex:i] getImageView] removeFromSuperview];
//                    //(パーティクルを生成していたら)パーティクルを消去
//                    [[[EnemyArray objectAtIndex:i] getDamageParticle] removeFromSuperview];
//                    [[[EnemyArray objectAtIndex:i] getExplodeParticle] removeFromSuperview];
//                    //配列から削除してメモリを解放
//                    [EnemyArray removeObjectAtIndex:i];
//                    break;
//                }
//            }
        }
//        if([EnemyArray count] > 30) {
//            [EnemyArray removeLastObject];
//        }
        
        
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
    
    
    //処理能力が低下するので自機以外のparticleを全て消去
    //敵の爆発パーティクルは全て消去
    for(int i = 0; i < [EnemyArray count] ;i++){
        if([[EnemyArray objectAtIndex:i] getIsAlive]){
            //ゲーム終了後に生存している敵の処理：消去？=>メモリ解放に役立たないのでやらない。
//            [[[EnemyArray objectAtIndex:i] getImageView]removeFromSuperview];
            
        }else{//死亡した敵の処理：爆発パーティクルは消去：メモリ消去
            [[[EnemyArray objectAtIndex:i] getExplodeParticle] removeFromSuperview];
            [[[EnemyArray objectAtIndex:i] getDamageParticle] removeFromSuperview];
            
            //画面からは消去せず(消去しても良いが)、配列から削除してメモリ解放
            [EnemyArray removeObjectAtIndex:i];
        }
    }
    
    //ItemClassのパーティクルは最後に生成された物(index:0)以外すべて消去
//    for(int i = 1; i < [KiraArray count];i++){
//        [[KiraArray objectAtIndex:i] removeFromSuperview];
//    }
    
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
    
    //ゲームオーバー(go)表示
//    int go_width = 250;
    int go_height = 50;
    int go_y = 10;//view_go上での相対位置
//    CGRect rect_gameover = CGRectMake(view_go.bounds.size.width/2 - go_component_width/2,
//                                      go_y,
//                                      go_component_width,
//                                      go_height);
//    [view_go addSubview:[CreateComponentClass createImageView:rect_gameover
//                                                        image:@"gameover.png"]];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"game over!";
    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont fontWithName:@"Chalkduster" size:40];
    label.font = [UIFont fontWithName:@"Noteworthy-Light" size:40];
    [label sizeToFit];
    //最後にview_goに貼付けているのでview_go上での位置
    label.center = CGPointMake([self.view convertPoint:view_go.center toView:view_go].x,
                               label.frame.size.height/2 + 5);//5はマージン
    [view_go addSubview:label];
    
    
    //[UIFont fontWithName:@"Noteworthy-Light" size:15];

    
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
    
    
    
    /*
     テスト
     */
//    [GoldBoard setScore:100];
//    [ScoreBoard setScore:10000];
    
    
    //マルチスレッド
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    //score:expに既に獲得したスコアを表示(pvはmaxは次のレベルに必要な値)
    //gold: pvは過去の最高値を横軸最大値とした軸
    //complete:100%を横軸最大値
    //三つとも最大値に達したら初期化してゼロからスタート
    //加えるべき値を別途定義してそれぞれ(pv_score等)に加えていく
    //上限まで達したら再度ゼロにして足していくが、次のレベルにおいても上限に達する場合はそこで停止しておく
    dispatch_async(globalQueue, ^{
        //ここでは情報を取得しておくに留める(更新は別の場所で実施)
        AttrClass *attr = [[AttrClass alloc]init];
        int level = [[attr getValueFromDevice:@"level"] intValue];
        int exp = [[attr getValueFromDevice:@"exp"] intValue];
        int expTilNextLevel = [attr getMaxExpAtTheLevel:level];
        
        
//        float unit = (float)expTilNextLevel / 100.0f;//progressViewの100分割ユニット＝最初のレベルで固定
        float unit = (float)[ScoreBoard getScore]/100.0f;
        
        
        //unitは取得スコア[ScoreBoard getScore]の100分割の方がすっきりする(最初のレベルにおけるレベルアップのための必要経験値の100分割にしてしまうと次のレベルに上がった時に１カウント当たりの上昇速度が低下してしまい時間がかかる)
        int loopCount = 100;//(float)(exp + [ScoreBoard getScore])/unit;
//        int loopCount = (float)(exp + 1000)/unit;//テスト用
//        int cntInit = 0;//(float)exp / unit;//最初のcntInitの表示はanimateしないようにしたい(現状x)
        int pvScoreValue = exp;
//        int goldCnt = 0;
        
        Boolean flagLevelUp = false;
        
        //exp初期値
        [pv_score setProgress:(float)pvScoreValue/100.0f
                     animated:NO];
        for(int cnt = 0;cnt < loopCount ||
                        cnt < [GoldBoard getScore]||
                        cnt < (float)enemyDown/(float)enemyCount*100;cnt++){
            for(int i = 0; i < 10;i++){
//                NSLog(@"i = %d", i);//時間経過
                NSLog(@"cnt = %d, i = %d, before-exp:%d, acquired:%d, after:%d, gold:%d, unit:%f, expUntileNextLevel:%d, level:%d, complete:%f, down:%d, count:%d",
                      cnt, i, exp, [ScoreBoard getScore], exp + [ScoreBoard getScore], [GoldBoard getScore], unit, expTilNextLevel, level, (float)enemyDown/enemyCount, enemyDown, enemyCount);
            }
            if(cnt < 100){
                if(pvScoreValue + unit < expTilNextLevel){
                    pvScoreValue += (int)unit;//小数点以下の誤差は発生するが
                }else{
//                    pvScoreValue = expTilNextLevel;
                    //次のレベルに進行
                    level++;
                    flagLevelUp = true;
                    expTilNextLevel = [attr getMaxExpAtTheLevel:level];
                    pvScoreValue = unit-pvScoreValue;
                    if(pvScoreValue > expTilNextLevel){//次のレベルのMAXよりも残り経験値が大きい場合
                        //経験値を沢山取得しても何度もレベル上昇するのは止めて次のレベルで止めておく
                        pvScoreValue = expTilNextLevel-1;
                    }
                }
            }

            dispatch_async(mainQueue, ^{
                //経験値
                if(cnt < loopCount-1){//最後のループのみ別処理(誤差修正のため)
                    tv_score.text = [NSString stringWithFormat:@"EXP : %d     level : %d",
                                     pvScoreValue , level];
                    if(!flagLevelUp){
                        [pv_score setProgress:(float)pvScoreValue/expTilNextLevel//levelが上がったら一旦初期化
                                     animated:NO];
                    }else{//レベルアップ時には一度ゼロに戻してから値を変更
                        [pv_score setProgress:0//levelが上がったら一旦初期化
                                     animated:NO];
                        [pv_score setProgress:(float)pvScoreValue/expTilNextLevel
                                     animated:YES];
                    }
                    
                }else{//unitが循環小数の場合(割り切れないので正確な値を示すために最終値をそのまま表示)
                    //初期値＋今回獲得スコア
                    tv_score.text = [NSString stringWithFormat:@"EXP : %d     level : %d",
                                         exp + [ScoreBoard getScore], level];
                }
                
                //gold
                if(cnt < [GoldBoard getScore]){
                    tv_gold.text = [NSString stringWithFormat:@"GOLD : %d", cnt+1];
                    
                }
                
                //complete
                if(cnt < (float)enemyDown/(float)enemyCount*100){
                    if(enemyDown != enemyCount){
                        tv_complete.text = [NSString stringWithFormat:@"complete : %d%%", cnt];
                        pv_complete.progress = (float)cnt / 100.0f;
                    }else{
                        tv_complete.text = [NSString stringWithFormat:@"complete : %d%%", 100];
                        pv_complete.progress = 1.0f;
                    }
                }

            });
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
