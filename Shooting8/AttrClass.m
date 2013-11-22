//
//  IDClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/14.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "AttrClass.h"

@implementation AttrClass{
    NSMutableArray *MaxExpArray;
}


/*
 *
 *(NSString *)getValueFromDevice:(NSString)name=name属性の値を取得する
 *(NSDictionary *)getAttrDict:
 */

-(id)init{
    self = [super init];
    
    
//    NSLog(@"aaa");//
    MaxExpArray = [[NSMutableArray alloc]init];
//    attrDict = [[NSDictionary alloc] init];
    for(int i = 0; i < 100; i ++){//level 100がマックス
        [MaxExpArray addObject:[NSNumber numberWithInt:((i+1)*100)]];//100, 200, 300, 400, 500, ・・・
    }
//    NSLog(@"bbb");//
    
    
    nameArray = [NSMutableArray arrayWithObjects:@"name",
                                 @"score",
                                 @"gold",
                                 @"login",
                                 @"gameCnt",
                                 @"level",
                                 @"exp",
                                 nil];
    
    NSLog(@"search in the device");
    //初期値をdeviceにセットする
    NSDictionary *_dict = [self getAttrDict];//

    //getAttrDictはデバイスから取得しているので以下は読み込んだ属性値をそのまま上書きしているだけなので不要
    for(int i = 0 ; i < [nameArray count] ; i++){
        [self setValueToDevice:[nameArray objectAtIndex:i]
                      strValue:[_dict objectForKey:[nameArray objectAtIndex:i]]];
    }
    
    return self;
}

-(int)getMaxExpAtTheLevel:(int)level{
    return [[MaxExpArray objectAtIndex:level] intValue];
}
/**
 *デバイス側にname,score,gold,login,gameCnt,level,expをNSString型として保存
 *returnAttrDictではそれらを読み込ませたattrDict(Dictionary)を作成
 */
-(NSDictionary *)getAttrDict{
    
    
//    NSMutableArray *valueArray = [[NSMutableArray alloc]init];
    NSMutableArray *valueArray = [NSMutableArray arrayWithObjects:@"no_name",//name
                           @"0",//score
                           @"0",//gold
                           @"0",//login
                           @"0",//gameCnt
                           @"1",//level
                           @"0",//exp
                           nil];
//    attrDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:nameArray];
    
    for(int i = 0; i < [nameArray count]; i++){
        if([self getValueFromDevice:[nameArray objectAtIndex:i]] != NULL){
            NSLog(@"getAttrDict : 番号：%d , 属性：%@ , 値：%@", i,
                  [nameArray objectAtIndex:i], 
                  [self getValueFromDevice:[nameArray objectAtIndex:i]]);
//            valueArray set = [[self getValueFromDevice:@"score"] intValue];
            [valueArray replaceObjectAtIndex:i withObject:(NSString *)[self getValueFromDevice:[nameArray objectAtIndex:i]]];
//            NSLog(@"test");
            
        }else{
            NSLog(@"device search for %@, but no data...", [nameArray objectAtIndex:i]);
            //nullならそのまま
        }
    }
    attrDict = [NSDictionary dictionaryWithObjects:valueArray forKeys:nameArray];
    
    
    return attrDict;
}

-(Boolean)removeAllData{
//    テスト用初期化=全データ消去
    
    NSUserDefaults *_ud = [NSUserDefaults standardUserDefaults];
    for(int i = 0 ; i < [nameArray count]; i++){
        [_ud removeObjectForKey:[nameArray objectAtIndex:i]];
        NSLog(@"removeAllData- attr:%@ , value:%@", [nameArray objectAtIndex:i],
              [_ud objectForKey:[nameArray objectAtIndex:i]]);
    }

    return true;
}

-(Boolean)addExp:(int)addingVal{
    //格納成功判定必要->格納失敗時はfalse
    NSLog(@"addExp");
    int beforeExp = [[self getValueFromDevice:@"exp"] intValue];
    int beforeLevel = [[self getValueFromDevice:@"level"] intValue];
    NSLog(@"現在レベル%dの経験値%dに%dを加算", beforeLevel, beforeExp , addingVal);

    int afterExp = beforeExp + addingVal;
    int _maxExp = [[MaxExpArray objectAtIndex:(beforeLevel-1)] intValue];
    NSLog(@"beforeExp = %d, beforeLevel = %d, afterExp = %d, _maxExp = %d",
          beforeExp, beforeLevel, afterExp, _maxExp);
    if ( afterExp > _maxExp){
        int afterLevel = beforeLevel + 1;
        [self setValueToDevice:@"level" strValue:[NSString stringWithFormat:@"%d", afterLevel]];
        NSLog(@"レベルアップ!%d->%d", beforeLevel, afterLevel);
        
        afterExp = afterExp - _maxExp;// - [[MaxExpArray objectAtIndex:afterLevel - 1] intValue];
        //afterExpがafterLevelにおけるMaxExpArrayの値を超過している可能性があるので入れ子にする
        [self setValueToDevice:@"exp" strValue:[NSString stringWithFormat:@"%d", 0]];
//        [self addExp:afterExp];
        [self setValueToDevice:@"exp" strValue:[NSString stringWithFormat:@"%d", [self addExp:afterExp]]];
         return afterExp;
    }
    [self setValueToDevice:@"exp" strValue:[NSString stringWithFormat:@"%d", afterExp]];
//    return afterExp;
    return true;
}



-(Boolean)setValueToDevice:(NSString *)NAME strValue:(NSString *)VALUE{
    
    NSLog(@"%@に%@を記憶させる", NAME, VALUE);
    //deviceに記憶させる
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
    [_myDefaults setObject:VALUE forKey:NAME];
    
    return true;
}
-(NSString *)getValueFromDevice:(NSString *)NAME{
    NSUserDefaults *_myDefaults = [NSUserDefaults standardUserDefaults];
//    [myDefaults setObject:dictionary forKey:@"DICTIONARY"];
//    NSDictionary *_dict = [_myDefaults dictionaryForKey:@"attrDict"];
    NSString *rtn_str = [_myDefaults objectForKey:NAME];
    return rtn_str;

}


/**
 *idは端末側に保存されているものとする(なければ新規作成)
 */


-(NSString *)getIdFromDevice{
    NSUserDefaults* id_defaults =
    [NSUserDefaults standardUserDefaults];
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    //    [id_defaults removeObjectForKey:@"user_id"];//値を削除：テスト用
    NSString *_registeredId = [id_defaults stringForKey:@"user_id"];
    NSLog(@"userid = %@", _registeredId);
    
    //端末に記録されたIDがない場合、十分に?長い(5桁)乱数を取得してIDとして記憶
    if(_registeredId == NULL){
        //取得
        //        NSLog(@"int max = %010d", INT_MAX);//2147483647
        int random_num = abs(arc4random()%100000);//0-99999=最大5桁の乱数
        //        random_num = 1;
        //        NSLog(@"rand = %d", random_num);
        NSDateFormatter *_dateformat = [[NSDateFormatter alloc] init];
        [_dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
        [_dateformat setDateFormat:@"yyyyMMddHHmmss"];//14桁
        NSString *_now = [_dateformat stringFromDate:[NSDate date]];
        //        NSLog(@"%@", _now);
        NSString *newId = [NSString stringWithFormat:@"%@%05d", _now, random_num];//yyyymmddhhmmss+5桁乱数=19桁=mysqlのbigIntの最大格納桁数
        //        NSString *newId = [NSString stringWithFormat:@"2013010101010100002"];//上記代替のテスト用id
        NSLog(@"新規取得userid = %@", newId);
        //端末記録
        NSUserDefaults *_ud = [NSUserDefaults standardUserDefaults];
        [_ud setObject:newId forKey:@"user_id"];
        
        _registeredId = newId;//
    }else{
        NSLog(@"既存idでログイン完了：user_id = %@", _registeredId);
    }
    return _registeredId;
}
@end
