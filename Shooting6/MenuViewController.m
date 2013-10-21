//
//  ItemSelectViewController.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/07.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "MenuViewController.h"
#import "GameClassViewController.h"
#import "ItemListViewController.h"
#import "CreateComponentClass.h"
#import <QuartzCore/QuartzCore.h>

//#define COMPONENT_00 0
//#define COMPONENT_01 1
//#define COMPONENT_02 2
//#define COMPONENT_03 3
//#define COMPONENT_04 4
//#define COMPONENT_05 5
//#define COMPONENT_06 6
//#define COMPONENT_07 7
//#define COMPONENT_08 8
//#define COMPONENT_09 9
//#define COMPONENT_10 10

#define MARGIN_UPPER_COMPONENT 5
#define Y_MOST_UPPER_COMPONENT 30
#define W_MOST_UPPER_COMPONENT 100
#define H_MOST_UPPER_COMPONENT 50

#define MARGIN_UPPER_TO_RANKING 2

#define W_RANKING_COMPONENT 300
#define H_RANKING_COMPONENT 200

#define MARGIN_RANKING_TO_FORMAL_BUTTON 10

#define SIZE_FORMAL_BUTTON 50
#define INTERVAL_FORMAL_BUTTON 10

#define MARGIN_FORMAL_TO_START 2

#define W_BT_START 150
#define H_BT_START 50

#define ALPHA_COMPONENT 0.5

NSMutableArray *imageFileArray;
NSMutableArray *tagArray;
NSMutableArray *titleArray;

UIView *subView;
UIButton *closeButton;//閉じるボタン
//CreateComponentClass *createComponentClass;

@interface MenuViewController ()

@end


//コンポーネント動的配置：http://d.hatena.ne.jp/mohayonao/20100719/1279524706
@implementation MenuViewController

@synthesize audioPlayer;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //back ground music
//        audioPlayerCapture = [self getAVAudioPlayer:@"mySoundEffects.caf" ];
//        [audioPlayerCapture prepareToPlay];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //タイトル配列
    titleArray = [NSArray arrayWithObjects:
                  [NSArray arrayWithObjects:
                   @"wpn",
                   @"drgn",
                   @"heal",
                   @"配合",
                   nil],
                  [NSArray arrayWithObjects:
                   @"buy",
                   @"item",
                   @"set",
                   @"gold",
                   nil],
                  nil];
//    imageFile = [[NSMutableArray alloc]init];
//    _imageFile = [NSArray arrayWithObjects:@"red.png", @"blue_item_yuri_big.png", nil];
    imageFileArray = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
//                       @"red.png",
//                       @"red.png",
//                       @"blue_item_yuri_big2.png",
//                       @"yellow_item_thunder.png",
                       nil],
                      [NSArray arrayWithObjects:
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
//                       @"red.png",
//                       @"yellow_item_thunder.png",
//                       @"red.png",
                       nil],
                      /*
                      [NSArray arrayWithObjects:
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
//                       @"red.png",
//                       @"yellow_item_thunder.png",
//                       @"red.png",
                       nil],
                      
                      [NSArray arrayWithObjects:
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
                       @"blue_item_yuri_big2.png",
//                       @"red.png",
//                       @"yellow_item_thunder.png",
//                       @"red.png",
                       nil],
                       */
                      nil];
//    NSLog(@"imageFileArray initialization complete");
    
    tagArray = [NSArray arrayWithObjects:
                [NSArray arrayWithObjects:@"200", @"201", @"202", @"203", nil],
                [NSArray arrayWithObjects:@"210", @"211", @"212", @"213", nil],
                [NSArray arrayWithObjects:@"220", @"221", @"222", @"223", nil],
                [NSArray arrayWithObjects:@"230", @"231", @"232", @"233", nil],
                nil];
//    NSLog(@"tagArray initialization complete");

	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    
    //BGM START
    NSLog(@"the naked king mp3");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TheNakedKing" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
    

//    NSLog(@"init select view controller start!!");
    int x_frame_center = (int)[[UIScreen mainScreen] bounds].size.width/2;
//    NSLog(@"%d" , x_frame_center);
//    int y_frame_center = (int)[[UIScreen mainScreen] bounds].size.height/2;//使用しない？
//    NSLog(@"中心＝%d", (int)[[UIScreen mainScreen] bounds].origin.x);
    
    //背景作成
//    UIImageView *iv_back = [self createImageView:@"chara_test2.png" tag:0 frame:[[UIScreen mainScreen] bounds]];
    UIImageView *iv_back = [self createImageView:@"chara_test2.png" tag:0 frame:CGRectMake(-110, -10, 680, 500)];
    
    iv_back.alpha = ALPHA_COMPONENT;
    [self.view sendSubviewToBack:iv_back];
    [self.view addSubview:iv_back];
    
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    
    //レベル表示部分:枠
    UIView *v_level =
    [CreateComponentClass createView:CGRectMake(x_frame_center - MARGIN_UPPER_COMPONENT - W_MOST_UPPER_COMPONENT*3/2,
                                                        Y_MOST_UPPER_COMPONENT,
                                                        W_MOST_UPPER_COMPONENT,
                                                        H_MOST_UPPER_COMPONENT)];
    [self.view addSubview:v_level];
    //レベル表示部分:ラベル
    CGRect rectLevelLabel = CGRectMake(x_frame_center - MARGIN_UPPER_COMPONENT - W_MOST_UPPER_COMPONENT*3/2 + 3,
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 50,
                                        W_MOST_UPPER_COMPONENT,
                                        H_MOST_UPPER_COMPONENT);
    UITextView *tvLevelLabel = [CreateComponentClass createTextView:rectLevelLabel
                                                                text:@"Lv."
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:15
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
    [self.view addSubview:tvLevelLabel];
    
    //レベル表示部分:数字
    CGRect rectLevelAmount = CGRectMake(x_frame_center - MARGIN_UPPER_COMPONENT - W_MOST_UPPER_COMPONENT*3/2 + 10,
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 30,
                                        W_MOST_UPPER_COMPONENT,
                                        H_MOST_UPPER_COMPONENT);
    UITextView *tvLevelAmount = [CreateComponentClass createTextView:rectLevelAmount
                                                          text:@"000000000"
                                                          font:@"AmericanTypewriter-Bold"
                                                          size:10
                                                     textColor:[UIColor whiteColor]
                                                     backColor:[UIColor clearColor]
                                                    isEditable:NO];
    [self.view addSubview:tvLevelAmount];
    
    
    
    
    
    //スコア表示部分:枠
    UIView *v_tokuten =
    [CreateComponentClass createView:CGRectMake(x_frame_center - W_MOST_UPPER_COMPONENT/2,
                                                Y_MOST_UPPER_COMPONENT,
                                                W_MOST_UPPER_COMPONENT,
                                                H_MOST_UPPER_COMPONENT)];
    [self.view addSubview:v_tokuten];
    //スコア表示部分:ラベル
    CGRect rectScoreLabel = CGRectMake(x_frame_center - W_MOST_UPPER_COMPONENT/2 + 3,
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 50,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    UITextView *tvScoreLabel = [CreateComponentClass createTextView:rectScoreLabel
                                                               text:@"Score."
                                                               font:@"AmericanTypewriter-Bold"
                                                               size:15
                                                          textColor:[UIColor whiteColor]
                                                          backColor:[UIColor clearColor]
                                                         isEditable:NO];
    [self.view addSubview:tvScoreLabel];
    
    //スコア表示部分:数字
    CGRect rectScoreAmount = CGRectMake(x_frame_center - W_MOST_UPPER_COMPONENT/2 + 10,
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 30,
                                        W_MOST_UPPER_COMPONENT,
                                        H_MOST_UPPER_COMPONENT);
    UITextView *tvScoreAmount = [CreateComponentClass createTextView:rectScoreAmount
                                                                text:@"9876543210"
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:10
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
    [self.view addSubview:tvScoreAmount];
    
    
    //獲得ゴールド数表示部分
    UIView *v_gold =
    [CreateComponentClass createView:CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2,
                                                Y_MOST_UPPER_COMPONENT,
                                                W_MOST_UPPER_COMPONENT,
                                                H_MOST_UPPER_COMPONENT)];
    [self.view addSubview:v_gold];
    //ゴールド表示部分:ラベル
    CGRect rectGoldLabel2 = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 7,    //影を先に付ける
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 46,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    UITextView *tvGoldLabel2 = [CreateComponentClass createTextView:rectGoldLabel2
                                                               text:@"Gold."
                                                               font:@"AmericanTypewriter-Bold"
                                                               size:15
                                                          textColor:[UIColor blackColor]
                                                          backColor:[UIColor clearColor]
                                                         isEditable:NO];
    [self.view addSubview:tvGoldLabel2];
    
    CGRect rectGoldLabel = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 3,
                                       Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 50,
                                       W_MOST_UPPER_COMPONENT,
                                       H_MOST_UPPER_COMPONENT);
    UITextView *tvGoldLabel = [CreateComponentClass createTextView:rectGoldLabel
                                                               text:@"Gold."
                                                               font:@"AmericanTypewriter-Bold"
                                                               size:15
                                                          textColor:[UIColor whiteColor]
                                                          backColor:[UIColor clearColor]
                                                         isEditable:NO];
    [self.view addSubview:tvGoldLabel];

    
    
    
    //ゴールド表示部分:数字
    CGRect rectGoldAmount = CGRectMake(x_frame_center + MARGIN_UPPER_COMPONENT + W_MOST_UPPER_COMPONENT/2 + 10,
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT - 30,
                                        W_MOST_UPPER_COMPONENT,
                                        H_MOST_UPPER_COMPONENT);
    UITextView *tvGoldAmount = [CreateComponentClass createTextView:rectGoldAmount
                                                                text:@"9876543210"
                                                                font:@"AmericanTypewriter-Bold"
                                                                size:10
                                                           textColor:[UIColor whiteColor]
                                                           backColor:[UIColor clearColor]
                                                          isEditable:NO];
    [self.view addSubview:tvGoldAmount];
    
    
    
    
    //ランキング表示部分
    UIView *v_ranking = [CreateComponentClass createView:CGRectMake(x_frame_center - W_RANKING_COMPONENT / 2,
                                                                    Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING,
                                                                    W_RANKING_COMPONENT,
                                                                    H_RANKING_COMPONENT)];
    [self.view addSubview:v_ranking];
    
//    UIImageView *iv_ranking = [self createImageView:@"black_128.png"
//                                             tag:103
//                                           frame:CGRectMake(x_frame_center - W_RANKING_COMPONENT / 2,
//                                                            Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING,
//                                                            W_RANKING_COMPONENT,
//                                                            H_RANKING_COMPONENT)];
//    iv_ranking.alpha = ALPHA_COMPONENT;
//    [[iv_ranking layer] setCornerRadius:10.0];
//    [iv_ranking setClipsToBounds:YES];
//    [self.view bringSubviewToFront:iv_ranking];
//    [self.view addSubview:iv_ranking];

    
    
//    NSLog(@"count = %d", [[imageFileArray objectAtIndex:0] count]);
    
    //各種アイコン表示部分
    for(int row = 0; row < [imageFileArray count];row++){
//        NSLog(@"row = %d", row);

        for(int col = 0; col < [[imageFileArray objectAtIndex:row] count] ;col++){
//            NSLog(@"row = %d, col = %d", row, col);
            CGRect rect_bt = CGRectMake(
                                        x_frame_center - (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * 2 +
                                        (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * col,
                                        
                                        Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING +
                                        H_RANKING_COMPONENT + MARGIN_RANKING_TO_FORMAL_BUTTON +
                                        (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * row,
                                        
                                        SIZE_FORMAL_BUTTON,
                                        SIZE_FORMAL_BUTTON);
            
//            UIButton *bt = [self createButtonWithImage:[[imageFileArray objectAtIndex:row] objectAtIndex:col]
//                                                   tag:[[[tagArray objectAtIndex:row] objectAtIndex:col ] intValue]//COMPONENT_00でも可
//                                                 frame:rect_bt];
//            [bt addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
            UIButton *bt = [CreateComponentClass createQBButton:ButtonTypeWithImage
                                                           rect:rect_bt
                                                          image:[[imageFileArray objectAtIndex:row] objectAtIndex:col]
                                                          title:[[titleArray objectAtIndex:row] objectAtIndex:col]
                                                         target:self
                                                       selector:@"pushed_button:"];
            
            bt.tag = [[[tagArray objectAtIndex:row] objectAtIndex:col] intValue];
            [self.view addSubview:bt];
            
//            NSLog(@"row = %d, col = %d, x = %d, y = %d, image = %@",
//                  row, col,
//                  (int)rect_bt.origin.x, (int)rect_bt.origin.y,
//                  [[imageFileArray objectAtIndex:row] objectAtIndex:col]);
        }
    }
    
    //スタートボタン表示部分
    CGRect rect_start = CGRectMake(x_frame_center - W_BT_START/2,
                                   Y_MOST_UPPER_COMPONENT + H_MOST_UPPER_COMPONENT + MARGIN_UPPER_TO_RANKING +
                                   H_RANKING_COMPONENT + MARGIN_RANKING_TO_FORMAL_BUTTON +
                                   (SIZE_FORMAL_BUTTON + INTERVAL_FORMAL_BUTTON) * [imageFileArray count] + MARGIN_FORMAL_TO_START,
                                   W_BT_START,
                                   H_BT_START);
//    UIButton *bt_start = [self createButtonWithImage:@"white_128.png"
//                                           tag:0
//                                         frame:rect_start];
//    
//    [bt_start addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *bt_start = [CreateComponentClass createButtonWithType:ButtonTypeWithImage
                                                               rect:rect_start
                                                              image:@"white_128.png"
                                                             target:self
                                                           selector:@"pushed_button:"];
    bt_start.tag = 0;
    
    //丸角
    [[bt_start layer] setCornerRadius:10.0];
    [bt_start setClipsToBounds:YES];
    [self.view addSubview:bt_start];
    
    
    //キャラ変更部分(購入部分)
    
    
    //機体数増加部分(購入ページ)
    
    NSLog(@"ItemViewController start");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushed_button: (id)sender
{
    NSLog(@"%d", [sender tag]);
    if ([sender tag] == 0) {
        NSLog(@"%d", 0);
    }
    switch([sender tag]){
        case 0:{
            NSLog(@"start games");
            
            //BGM STOP
            if( !audioPlayer.playing ){
                [audioPlayer play];
            } else {
                [audioPlayer pause];
            }
            
            GameClassViewController *gameView = [[GameClassViewController alloc] init];
            [self presentViewController: gameView animated:YES completion: nil];
            //参考戻る時(時間経過等ゲーム終了時で)：[self dismissModalViewControllerAnimated:YES];=>deprecated
//            NSLog(@"return");
//            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        //上段
        case 200:{//武器バージョンアップ
            subView = [CreateComponentClass createView];
            [self.view bringSubviewToFront:subView];
            [self.view addSubview:subView];
            
            
            CGRect rect_close = CGRectMake(285, 57, 20, 20);
//            closeButton = [self createButtonWithImage:@"close.png" tag:999 frame:rect_close];
            closeButton = [CreateComponentClass createButtonWithType:ButtonTypeWithImage
                                                                rect:rect_close
                                                               image:@"close.png"
                                                              target:self
                                                            selector:@"pushed_button:"];//selector記述する必要あり。
            closeButton.tag = 999;//
            [self.view addSubview:closeButton];
            break;
        }
        case 201:{//ドラゴン選択(フリックで選択)
            
            NSArray *imageArray = [NSArray arrayWithObjects:@"close.png",
                                  @"close.png",
                                  @"close.png",
                                  @"close.png",
                                  @"close.png",
                                  @"close.png",
                                  @"close.png",
                                  @"close.png",
                                  @"close.png",
                                  @"close.png",
                                  nil];
            //画面中央部にイメージファイル、その周りに半透明ビュー、更にその周囲に透明ビュー(イメージ以外をタップすると消える)
            UIView *superView = [CreateComponentClass createSlideShow:self.view.bounds
                                                            imageFile:imageArray
                                                               target:self
                                                            selector1:@"closeView:"
                                                            selector2:@"imageTapped:"];
            superView.tag = 0;
            [self.view addSubview:superView];
            
            
            break;
        }
        case 202:{//回復
            ItemListViewController *ilvc = [[ItemListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case 203:{//配合
            break;
        }
        //下段
        case 210:{//ドラゴン購入？＝＞ドラゴン選択と同じで良い？
            break;
        }
        case 211:{//アイテム
            ItemListViewController *ilvc = [[ItemListViewController alloc]init];
            [self presentViewController: ilvc animated:YES completion: nil];
            break;
        }
        case 212:{//設定画面：BGM,効果音、操作感度、ボイス、難易度
            UIView *viewSuper = [CreateComponentClass createViewNoFrame:self.view.bounds
                                                                  color:[UIColor clearColor]
                                                                    tag:9999
                                                                 target:self
                                                               selector:@"closeView:"];//透明ビュー
            [viewSuper setBackgroundColor:[UIColor colorWithRed:0.0f green:0 blue:0 alpha:0.7f]];
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(100, 70, 210, 250)];
            [viewFrame setBackgroundColor:[UIColor colorWithRed:0.1f green:0.6f blue:0.1f alpha:0.6f]];//どちらでも良い
            
            int imageInitX = 10;
            int imageInitY = 10;
            int imageWidth = 70;
            int imageHeight = 70;
            int imageMargin = 10;
//            NSArray *image_array = [NSArray arrayWithObjects:@"bgm.png",@"sound.png", @"difficulty.png",nil] ;
            NSArray *image_array = [NSArray arrayWithObjects:@"close.png",@"close.png", @"close.png",nil] ;
            
            for (int i = 0; i < [image_array count]; i++){
                CGRect rect_image = CGRectMake(imageInitX,
                                               imageInitY + i * (imageHeight + imageMargin),
                                               imageWidth,
                                               imageHeight);
                
                UIImageView *iv_item = [CreateComponentClass createImageView:rect_image
                                                                      image:[image_array objectAtIndex:i]
                                                                        tag:[[NSString stringWithFormat:@"%d%d", 212, i] intValue]
                                                                     target:self
                                                                   selector:@"imageTapped:"];
//                iv_item.tag = 1;
                [viewFrame addSubview:iv_item];
            }
            
            [viewSuper addSubview:viewFrame];
            [self.view addSubview:viewSuper];
            
            break;
        }
        case 213:{//課金画面
            break;
        }
            /*
        case 220:{
            break;
        }
        case 221:{
            break;
        }
        case 222:{
            break;
        }
        case 223:{
            break;
        }
             */
        case 999:{
            [subView removeFromSuperview];
            [closeButton removeFromSuperview];
            break;
        }
        case 9999:{
            NSLog(@"pushed close button 9999");
            break;
        }
            
    }
}

-(void)imageTapped:(id)sender{
    NSLog(@"imageTapped at tag = %d", [sender view].tag);

    UIView *tappedView = [sender view];
    NSLog(@"imageTapped at tag = %d", tappedView.tag);
    switch(tappedView.tag){
        case 0://slideshowでタップされた場合=>出来ればtypedef NS_ENUMでグローバルに変数宣言しておく。例：TAPPED_SLIDESHOW
        {
            //他のタップレコナイザをunableにするため全体のビューを作成
            UIView *viewAll = [[UIView alloc]initWithFrame:self.view.bounds];
            [viewAll setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9f]];//タップイベントを受け付けないビューを画面全体に配置
            UIView *viewFrame = [CreateComponentClass createView:CGRectMake(10, 80, 300, 300)];
            [viewFrame setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f]];
            UIButton *bt = [CreateComponentClass createButtonWithType:ButtonTypeWithImage
                                                                 rect:CGRectMake(260, 50, 25, 25)
                                                                image:@"close.png"
                                                               target:self
                                                             selector:@"closeSuperSuperView:"];//親クラスを削除する
            bt.tag = 9999;
            [viewFrame addSubview:bt];
            [viewAll addSubview:viewFrame];
            [self.view addSubview:viewAll];

            
            break;
            
        }
        case 2:
        {
            break;
        }
        case 2120://TAPPED_BGM
        {
            NSLog(@"tapped image");
            if( !audioPlayer.playing ){
                [audioPlayer play];
            } else {
                [audioPlayer pause];
            }
            break;
        }
        case 2121://TAPPED_BGM
        {
            NSLog(@"tapped image");
            break;
        }case 2122://TAPPED_BGM
        {
            NSLog(@"tapped image");
            break;
        }
        default :{
            break;
        }
    
    }
    return;
}

-(void)closeView:(id)sender{
    NSLog(@"close view");
    [[sender view]removeFromSuperview];
}

-(void)closeSuperView:(id)sender{
    NSLog(@"close superview");
    [[sender superview]removeFromSuperview];
    
}
-(void)closeSuperSuperView:(id)sender{
    NSLog(@"close superview");
    [[[sender superview] superview ]removeFromSuperview];
    
}

//-(UIButton*)createButtonWithImage:(NSString*)imageFile tag:(int)tag frame:(CGRect)frame
//{
//    //画像を表示させる場合：http://blog.syuhari.jp/archives/1407
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = frame;
//    button.tag   = tag;
//    UIImage *image = [UIImage imageNamed:imageFile];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(pushed_button:)
//     forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//-(UIButton*)createButtonWithTitle:(NSString*)title tag:(int)tag frame:(CGRect)frame
//{
//    //画像を表示させる場合：http://blog.syuhari.jp/archives/1407
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = frame;
//    button.tag   = tag;
//    [button setTitle:title forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(pushed_button:)
//     forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}


-(UIImageView*)createImageView:(NSString*)filename tag:(int)tag frame:(CGRect)frame{
    UIImageView *iv = [[UIImageView alloc] initWithFrame:frame];
    iv.tag = tag;
    iv.image = [UIImage imageNamed:filename];
    return iv;
}





@end
