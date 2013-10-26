//
//  ScoreBoardClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/05.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ScoreBoardClass.h"
#import "CreateComponentClass.h"

@implementation ScoreBoardClass

-(id)init:(int)_score x_init:(int)x_init y_init:(int)y_init ketasu:(int)_ketasu{//端末自体のフレームの大きさを引数にした
    
    
    score = _score;
    xStart = x_init;//frame.size.width - (rightMargin + eachDigitWidth * maxKetasu);//左端
    yStart = y_init;
    ketasu = _ketasu;

    //デジタル表記用
    numberImageViewArray = [[NSMutableArray alloc]init];
    scoreDigitalArray = [[NSMutableArray alloc]init];
    [numberImageViewArray addObject:@"small_zero.png"];
    [numberImageViewArray addObject:@"small_one.png"];
    [numberImageViewArray addObject:@"small_two.png"];
    [numberImageViewArray addObject:@"small_three.png"];
    [numberImageViewArray addObject:@"small_four.png"];
    [numberImageViewArray addObject:@"small_five.png"];
    [numberImageViewArray addObject:@"small_six.png"];
    [numberImageViewArray addObject:@"small_seven.png"];
    [numberImageViewArray addObject:@"small_eight.png"];
    [numberImageViewArray addObject:@"small_nine.png"];
    int overlap = 8;//イメージファイル同士の重なり幅(隣同士ぴったりにすると間が空きすぎるため)
    int eachDigitWidth = 20;//各桁のimage幅は25px
    int eachDigitHeight = 40;
    //    rightMargin = 10;//右端の余白は10px
    //score_arrayの初期化
    for(int keta_count = 0;keta_count < ketasu;keta_count ++){
        UIImageView *_eachDigit = [[UIImageView alloc]initWithFrame:CGRectMake(xStart + (eachDigitWidth - overlap) * keta_count,
                                                                               yStart,
                                                                               eachDigitWidth,
                                                                               eachDigitHeight)];
        _eachDigit.image = [UIImage imageNamed:[numberImageViewArray objectAtIndex:0]];
        [scoreDigitalArray addObject:_eachDigit];
    }
    
    
    //テキストビュー表記用
    CGRect rect_score = CGRectMake(xStart, yStart, 140, 50);
    tv_score = [CreateComponentClass createTextView:rect_score
                                               text:[self get0FillString]
                                               font:@"AmericanTypewriter-Bold"
                                               size:16
                                          textColor:[UIColor whiteColor]
                                          backColor:[UIColor clearColor]
                                         isEditable:NO];
    
    
    
    [self setScore:score];
    
    return self;
}

-(void)setScore:(int)_score{
    score = _score;
    
    
}

-(int)getScore{
    return score;
}

-(NSString *)get0FillString{
    //桁数を動的に変更することはできない？
    //    NSString *str_ketasu = [NSString stringWithFormat:@"03d", maxKetasu];
    //    NSString *temp1 = [[NSString stringWithFormat:@"%"] stringByAppendingFormat:[str_ketasu stringByAppendingString:@"d"]];

    if(score >= 0){
        //以下はketasu=10桁の場合=>桁数によって変える必要がある。
        return [NSString stringWithFormat:@"%010d", score];
    }
    return nil;
}

-(UITextView *)getTextView{

    tv_score.text = [self get0FillString];
    
    return tv_score;
}

-(NSMutableArray *)getDigitalArray{
    
    
    NSString *moji = [self get0FillString];
    //    UIImageView *_eachDigit;
    //    NSLog(@"start");
    for(int keta_count = 0; keta_count < ketasu; keta_count++){
        //        NSLog(@"keta = %d", ketasu);
        for(int loopCount = 0; loopCount < [scoreDigitalArray count]; loopCount++){
            //            NSLog(@"lc = %d, searchNum = %d", loopCount, [[moji substringWithRange:NSMakeRange(ketasu, 1)] intValue]);
            if(loopCount == [[moji substringWithRange:NSMakeRange(keta_count, 1)] intValue]){
                
                //                _eachDigit = [[UIImageView alloc]initWithFrame:CGRectMake(xStart + (eachDigitWidth) * ketasu,
                //                                                                          yStart,
                //                                                                          eachDigitWidth,
                //                                                                          eachDigitHeight)];
                ((UIImageView *)[scoreDigitalArray objectAtIndex:keta_count]).image = [UIImage imageNamed:[numberImageViewArray objectAtIndex:loopCount]];
                //                    [score_array addObject:_eachDigit];//追加してはだめ(二重ループで順番がめちゃくちゃなため)
                //                    [score_array replaceObjectAtIndex:ketasu withObject:_eachDigit];
                break;
            }
        }
    }
    
    //    NSLog("finish");
    

    return scoreDigitalArray;
}

@end
