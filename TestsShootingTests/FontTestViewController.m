//
//  FontTestViewController.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/17.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "FontTestViewController.h"

@interface FontTestViewController ()

@end

@implementation FontTestViewController

NSArray *allFontName;
NSArray *kohoFontName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    kohoFontName = [NSArray arrayWithObjects:
                    @"AmericanTypewriter-Bold",//oo
                    @"Helvetica-Bold",//o
                    @"Verdana-BoldItalic",//o
                    @"Georgia-BoldItalic",//o
                    nil
                    
                    ];
    allFontName = [NSArray arrayWithObjects:
                @"Hiragino Kaku Gothic ProN W3",//0
                @"HiraKakuProN-W3",
                @"Courier",
                @"Courier",
                @"Courier-BoldOblique",
                @"Courier-Oblique",
                @"Courier-Bold",
                @"Arial",
                @"ArialMT",
                @"Arial-BoldMT",
                
                
                @"Arial-BoldItalicMT",//1
                @"Arial-ItalicMT",
                @"STHeiti TC",
                @"STHeitiTC-Light",
                @"STHeitiTC-Medium",
                @"AppleGothic",
                @"AppleGothic",
                @"Courier New",
                @"CourierNewPS-BoldMT",
                @"CourierNewPS-ItalicMT",
                
                
                @"CourierNewPS-BoldItalicMT",//2
                @"CourierNewPSMT",
                @"Zapfino",
                @"Zapfino",
                @"Hiragino Kaku Gothic ProN W6",
                @"HiraKakuProN-W6",
                @"Arial Unicode MS",
                @"ArialUnicodeMS",
                @"STHeiti SC",
                @"STHeitiSC-Medium",
                
                
                @"STHeitiSC-Light",//3
                @"American Typewriter",
                @"AmericanTypewriter",
                @"AmericanTypewriter-Bold",//o
                @"Helvetica",
                @"Helvetica-Oblique",
                @"Helvetica-BoldOblique",
                @"Helvetica",
                @"Helvetica-Bold",//o
                @"Marker Felt",
                
                
                @"MarkerFelt-Thin",//4
                @"Helvetica Neue",
                @"HelveticaNeue",
                @"HelveticaNeue-Bold",
                @"DB LCD Temp",
                @"DBLCDTempBlack",
                @"Verdana",
                @"Verdana-Bold",
                @"Verdana-BoldItalic",//o
                @"Verdana",
                
                
                @"Verdana-Italic",//5
                @"Times New Roman",
                @"TimesNewRomanPSMT",
                @"TimesNewRomanPS-BoldMT",
                @"TimesNewRomanPS-BoldItalicMT",
                @"TimesNewRomanPS-ItalicMT",
                @"Georgia",
                @"Georgia-Bold",
                @"Georgia",
                @"Georgia-BoldItalic",//o
                
                
                @"Georgia-Italic",//6
                @"STHeiti J",
                @"STHeitiJ-Medium",
                @"STHeitiJ-Light",
                @"Arial Rounded MT Bold",
                @"ArialRoundedMTBold",
                @"Trebuchet MS",
                @"TrebuchetMS-Italic",
                @"TrebuchetMS",
                @"Trebuchet-BoldItalic",
                
                
                @"TrebuchetMS-Bold",//7
                @"STHeiti K",
                @"STHeitiK-Medium",
                @"STHeitiK-Light",
                nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //背景
    // 背景に画像をセットする
    UIImage *bgImage = [UIImage imageNamed:@"close.png"];
//    self.view.backgroundColor=[UIColor colorWithPatternImage: bgImage];
    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bg.image = bgImage;
    [self.view addSubview:bg];
    
//    int dispHeight = 23;
    //フォント全て表示
//    for(int i = 0; i < [allFontName count];i++){
//        NSLog(@"%d", i);
//        UITextView *tv = [[UITextView alloc]init];
//        if(i < 20){
//            tv.frame = CGRectMake(5, i * dispHeight, 300, dispHeight);
//            
//        }else if(i < 40){
//            tv.frame = CGRectMake(5 + 80, i * dispHeight - dispHeight * 20, 300, dispHeight);
//            
//        }else if(i < 60){
//            tv.frame = CGRectMake(5 + 160, i * dispHeight - dispHeight * 40, 300, dispHeight);
//            
//        }else if(i < 80){
//            tv.frame = CGRectMake(5 + 240, i * dispHeight - dispHeight * 60, 300, dispHeight);
//            
//        }
//        [tv setFont:[UIFont fontWithName:[allFontName objectAtIndex:i ] size:10]];
//        tv.text = [NSString stringWithFormat:@"%d%@", i%10, @"0123456789"];
//        tv.textColor = [UIColor whiteColor];
//        tv.backgroundColor = [UIColor grayColor];
//        tv.editable = NO;
//        [self.view addSubview:tv];
//    }
    
    int dispHeight = 100;
    //候補
    for(int i = 0; i < [kohoFontName count];i++){
        NSLog(@"%d", i);
        UITextView *tv = [[UITextView alloc]init];
        if(i < 20){
            tv.frame = CGRectMake(5, i * dispHeight, 300, dispHeight);
            
        }else if(i < 40){
            tv.frame = CGRectMake(5 + 80, i * dispHeight - dispHeight * 20, 300, dispHeight);
            
        }else if(i < 60){
            tv.frame = CGRectMake(5 + 160, i * dispHeight - dispHeight * 40, 300, dispHeight);
            
        }else if(i < 80){
            tv.frame = CGRectMake(5 + 240, i * dispHeight - dispHeight * 60, 300, dispHeight);
            
        }
        [tv setFont:[UIFont fontWithName:[kohoFontName objectAtIndex:i ] size:20]];
//        tv.text = [NSString stringWithFormat:@"%d%@", i%10, @"0123456789"];
        tv.text = [NSString stringWithFormat:@"%d%@", i%10, @"ABCDEFGHIJKLMNOPQRSTUVWXYZ:0123456789"];
        tv.textColor = [UIColor whiteColor];
        tv.backgroundColor = [UIColor grayColor];
        tv.editable = NO;
        [self.view addSubview:tv];
        
        //=>@"AmericanTypewriter-Bold"に決定
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
