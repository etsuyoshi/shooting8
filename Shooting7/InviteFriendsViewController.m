//
//  InviteFriendsViewController.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/24.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import <AppSocially/AppSocially.h>

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController

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
    
    //ナビゲーションバー設置
    UINavigationBar* objectNaviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, 40)];
    objectNaviBar.alpha = 0.8f;
    
    // ナビゲーションアイテムを生成
    UINavigationItem* naviItem = [[UINavigationItem alloc] initWithTitle:@"タイトル"];
    
    // 戻るボタンを生成
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clickBack)];
    
    // ナビゲーションアイテムの右側に戻るボタンを設置
    naviItem.leftBarButtonItem = backButton;
    
    
    //appsocially機能追加
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close.png"]
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(invite:)];
//    barBtn.image = [UIImage imageNamed:@"close.png"];
    naviItem.rightBarButtonItem = barBtn;
    
    // ナビゲーションバーにナビゲーションアイテムを設置
    [objectNaviBar pushNavigationItem:naviItem animated:YES];
    
    // ビューにナビゲーションアイテムを設置
    [self.view addSubview:objectNaviBar];


    
    
//    [self.view addSubview:barBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)invite:(UIButton *)sender {
    
    [ASInviter showInviteSheetInView:self.view];
}

-(void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
