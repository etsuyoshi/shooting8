//
//  GoldBoardClass.m
//  Shooting5
//
//  Created by 遠藤 豪 on 13/10/05.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "GoldBoardClass.h"

@implementation GoldBoardClass

-(id)init:(int)_type x_init:(int)_x_init y_init:(int)_y_init ketasu:(int)_ketasu{
    self = [super init:_type x_init:_x_init y_init:_y_init ketasu:_ketasu];
    
    return self;
}

-(id)init:(int)_type x_init:(int)_x_init y_init:(int)_y_init ketasu:(int)_ketasu type:(NSString *)type{
    //textViewモードの場合はGoldBoardの高さを少し上げる
    if([type isEqualToString:@"gold"]){
        self = [super init:_type x_init:_x_init y_init:_y_init - 20 ketasu:_ketasu];
    }else{
        self = [super init:_type x_init:_x_init y_init:_y_init ketasu:_ketasu];
    }
    return self;
}


@end
