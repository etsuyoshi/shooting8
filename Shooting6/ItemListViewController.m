//
//  ItemListViewController.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ItemListViewController.h"
#import "CreateComponentClass.h"

@interface ItemListViewController ()

@end

@implementation ItemListViewController

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
    
    //backgroundの設定
    UIImageView *background = [[UIImageView alloc]initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"chara_test2.png"];
    background.alpha = 0.5f;
    [self.view sendSubviewToBack:background];
    [self.view addSubview:background];
    
    //cash　frame
    int cashFrameWidth = 150;
    int cashFrameHeight = 50;
    int cashFrameInitX = 165;
    int cashFrameInitY = 40;
    UIView *cashView = [CreateComponentClass createView:CGRectMake(cashFrameInitX,
                                                                   cashFrameInitY,
                                                                   cashFrameWidth,
                                                                   cashFrameHeight)];
    [self.view addSubview:cashView];
    
    //cash image
    UIImageView *cashIV = [[UIImageView alloc]initWithFrame:CGRectMake(cashFrameInitX + 10,
                                                                       cashFrameInitY + 10, 15, 15)];
    cashIV.image = [UIImage imageNamed:@"close.png"];
    [self.view addSubview:cashIV];
    
    
    
    
    //frame
    int itemFrameWidth = 300;
    int itemFrameHeight = 75;
    int itemFrameInitX = 10;
    int itemFrameInitY = 100;
    int itemFrameInterval = 10;
    
    int imageFrameWidth = itemFrameWidth / 6;
    int imageFrameHeight = itemFrameHeight - 20;
    int imageFrameInitX = itemFrameInitX + 10;
    int imageFrameInitY = itemFrameInitY + 10;
    int imageFrameInterval = itemFrameInterval + 20;
    for(int i = 0; i < 4; i++){
        //frame作成
        UIView *eachView = [CreateComponentClass createView:CGRectMake(itemFrameInitX,
                                                                itemFrameInitY + i * (itemFrameHeight + itemFrameInterval),
                                                                itemFrameWidth,
                                                                itemFrameHeight)];
        [self.view addSubview:eachView];
        
        //imageの貼付
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(imageFrameInitX,
                                                                   imageFrameInitY + i * (imageFrameHeight + imageFrameInterval),
                                                                   imageFrameWidth,
                                                                   imageFrameHeight)];
        iv.image = [UIImage imageNamed:@"close.png"];
        [self.view addSubview:iv];
        
        //名称、説明文の貼付：配列等にしておく必要あり
        UITextView *tv = [[UITextView alloc]initWithFrame:CGRectMake(imageFrameInitX + imageFrameWidth + 10,
                                                                     itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + 10,
                                                                     itemFrameWidth / 2,
                                                                     itemFrameHeight - 20)];
//        tv.alpha = 0.5f;//文字色にも適用されてしまう
        tv.backgroundColor = [UIColor clearColor];
        tv.font = [UIFont fontWithName:@"Arial" size:24.0f];
        tv.textColor = [UIColor whiteColor];
        tv.text = @"explanation";
        tv.editable = NO;
        [self.view addSubview:tv];
        
        //プラスボタンの貼付
        CGRect btnRect = CGRectMake(imageFrameInitX + imageFrameWidth + 10 + itemFrameWidth / 2 + 20,
                                    itemFrameInitY + i * (itemFrameHeight + itemFrameInterval) + 10,
                                    imageFrameWidth,
                                    imageFrameHeight);
        UIButton *btn = [CreateComponentClass createQBButton:0
                                                        rect:btnRect
                                                       image:nil
                                                      target:self
                                                    selector:@"buyBtnPressed"];
        [self.view addSubview:btn];
        
    }
    
    
    
    //参考戻る時(時間経過等ゲーム終了時で)：[self dismissModalViewControllerAnimated:YES];
    //            NSLog(@"return");
    //            [self dismissViewControllerAnimated:YES completion:nil];
    UIButton *closeBtn = [CreateComponentClass createButtonWithType:ButtonTypeWithImage
                                                               rect:CGRectMake(300, 3, 20, 20)
                                                              image:@"close.png"
                                                             target:self
                                                           selector:@"closeBtnClicked"];
    
    [self.view addSubview:closeBtn];
}

-(void)closeBtnClicked{
    NSLog(@"close");
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)buyBtnPressed{
    NSLog(@"buy button pressed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
