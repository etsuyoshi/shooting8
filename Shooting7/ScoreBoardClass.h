//
//  ScoreBoardClass.h
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/05.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreBoardClass : NSObject{
    int score;
    int xStart;//開始位置x
    int yStart;//開始位置y
    int ketasu;//桁数
    
    //デジタル表記用
    NSMutableArray *scoreDigitalArray;
    NSMutableArray *numberImageViewArray;
    
    //テキストビュー表記用
    UITextView *tv_score;
}

-(id)init:(int)type x_init:(int)x_init y_init:(int)y_init ketasu:(int)ketasu;
-(UITextView *)getTextView;
-(NSMutableArray *)getDigitalArray;
-(void)setScore:(int)_score;
-(int)getScore;
@end
