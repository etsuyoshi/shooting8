//
//  ScoreBoardClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/05.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ScoreBoardClass.h"

@implementation ScoreBoardClass







-(id)init:(int)_score x_init:(int)x_init y_init:(int)y_init{//端末自体のフレームの大きさを引数にした
    
    
    score = _score;
    xStart = x_init;//frame.size.width - (rightMargin + eachDigitWidth * maxKetasu);//左端
    yStart = y_init;

        
    
    [self setScore:score];
    
    return self;
}

-(void)setScore:(int)_score{
    score = _score;
    
    
}

-(int)getScore{
    return score;
}


-(NSMutableArray *)getDigitalArray{
    
    int eachDigitWidth;
    int eachDigitHeight;
    int maxKetasu;
    NSMutableArray *strEnglishNum;
    NSMutableArray *score_array;
    int overlap = 8;//イメージファイル同士の重なり幅(隣同士ぴったりにすると間が空きすぎるため)
    eachDigitWidth = 20;//各桁のimage幅は25px
    eachDigitHeight = 40;
    //    rightMargin = 10;//右端の余白は10px
    strEnglishNum = [[NSMutableArray alloc]init];
    [strEnglishNum addObject:@"small_zero.png"];
    [strEnglishNum addObject:@"small_one.png"];
    [strEnglishNum addObject:@"small_two.png"];
    [strEnglishNum addObject:@"small_three.png"];
    [strEnglishNum addObject:@"small_four.png"];
    [strEnglishNum addObject:@"small_five.png"];
    [strEnglishNum addObject:@"small_six.png"];
    [strEnglishNum addObject:@"small_seven.png"];
    [strEnglishNum addObject:@"small_eight.png"];
    [strEnglishNum addObject:@"small_nine.png"];
    
    score_array = [[NSMutableArray alloc]init];
    maxKetasu = 10;
    
    //score_arrayの初期化
    for(int ketasu = 0;ketasu < maxKetasu;ketasu ++){
        UIImageView *_eachDigit = [[UIImageView alloc]initWithFrame:CGRectMake(xStart + (eachDigitWidth - overlap) * ketasu,
                                                                               yStart,
                                                                               eachDigitWidth,
                                                                               eachDigitHeight)];
        _eachDigit.image = [UIImage imageNamed:@"small_zero.png"];
        [score_array addObject:_eachDigit];
        
    }

    
    NSString *moji = [ NSString stringWithFormat : @"%010d", score];//桁数によって変える必要がある。
    //    UIImageView *_eachDigit;
    //    NSLog(@"start");
    for(int ketasu = 0; ketasu < maxKetasu; ketasu++){
        //        NSLog(@"keta = %d", ketasu);
        for(int loopCount = 0; loopCount < [score_array count]; loopCount++){
            //            NSLog(@"lc = %d, searchNum = %d", loopCount, [[moji substringWithRange:NSMakeRange(ketasu, 1)] intValue]);
            if(loopCount == [[moji substringWithRange:NSMakeRange(ketasu, 1)] intValue]){
                
                //                _eachDigit = [[UIImageView alloc]initWithFrame:CGRectMake(xStart + (eachDigitWidth) * ketasu,
                //                                                                          yStart,
                //                                                                          eachDigitWidth,
                //                                                                          eachDigitHeight)];
                ((UIImageView *)[score_array objectAtIndex:ketasu]).image = [UIImage imageNamed:[strEnglishNum objectAtIndex:loopCount]];
                //                    [score_array addObject:_eachDigit];//追加してはだめ(二重ループで順番がめちゃくちゃなため)
                //                    [score_array replaceObjectAtIndex:ketasu withObject:_eachDigit];
                break;
            }
        }
    }
    
    //    NSLog("finish");
    

    return score_array;
}

@end
