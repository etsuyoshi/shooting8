//
//  ViewController.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

//DB側でログイン回数をカウントする(カラム追加、値取得して１を足す)

#import "InitViewController.h"
#import "ItemSelectViewController.h"
#import "DBAccessClass.h"
#import "AttrClass.h"

@interface InitViewController ()

@end

@implementation InitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    CGRect rect_frame = [[UIScreen mainScreen] bounds];
    CGRect rect_main = CGRectMake(0,30, 320, 320);
    UIImageView *iv_frame = [[UIImageView alloc]initWithFrame:rect_main];
    iv_frame.image = [UIImage imageNamed:@"chara_test2.png"];
    
    [self.view addSubview:iv_frame];
    
    
    //ユーザー認証
    DBAccessClass *dbac = [[DBAccessClass alloc]init];
    //端末からidを取得してdbと照合(なければdbと端末自体に新規作成)
//    [dbac setIdToDB:[dbac getIdFromDevice]];
    AttrClass *attr = [[AttrClass alloc]init];
    NSString *_id = [attr getIdFromDevice];
    if([dbac setIdToDB:_id]){//dbに登録(既存idならばそのまま)
        NSLog(@"データベース登録or承認完了");
    }else{
        NSLog(@"データベース登録or承認失敗");
    }
    
    
    /*
    NSString *output = [dbac getValueFromDB:_id column:@"score"];
    NSLog(@"output = %@", output);
    [dbac updateValueToDB:_id column:@"score" newVal:@"100"];
    
    output = [dbac getValueFromDB:_id column:@"score"];
    NSLog(@"output = %@", output);
    
    NSMutableArray *nameArray = [NSArray arrayWithObjects:@"name",
                             @"score",
                             @"gold",
                             @"login",
                             @"gameCnt",
                             @"level",
                             @"exp",
                             nil];
    
    NSUserDefaults *_ud = [NSUserDefaults standardUserDefaults];
    for(int i = 0 ; i < [nameArray count]; i++){
        NSLog(@"%@ = %@", [nameArray objectAtIndex:i],
              [_ud objectForKey:[nameArray objectAtIndex:i]]);
    }

    [attr setValueToDevice:@"exp" strValue:@"100"];
    [attr addExp:200];
    for(int i = 0 ; i < [nameArray count]; i++){
        NSLog(@"%@ = %@", [nameArray objectAtIndex:i],
              [_ud objectForKey:[nameArray objectAtIndex:i]]);
    }
     */
    



}
-(void)viewDidAppear:(BOOL)animated{
    //viewDidLoadの次に呼び出される
    CGRect rect_frame = [[UIScreen mainScreen] bounds];
    UIButton *bt = [self createButtonWithTitle:@"start"
                                           tag:0
                                         frame:CGRectMake(rect_frame.size.width/2 - 50,
                                                          rect_frame.size.height/2 + 130,
                                                          100,
                                                          40)];
    
    
    [bt addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushed_button:(id)sender{
    UIStoryboard *storyboard = nil;

    switch([sender tag]){
        case 0:
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ItemSelectViewController"];
            //    NSLog(@"%@", vc);
            [self presentViewController: vc animated:YES completion: nil];
            break;
//        case 1:
//            NSLog(@"bb@");
//            break;

    }
}
-(UIButton*)createButtonWithTitle:(NSString*)title tag:(int)tag frame:(CGRect)frame
{
    //画像を表示させる場合：http://blog.syuhari.jp/archives/1407
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    button.tag   = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushed_button:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
