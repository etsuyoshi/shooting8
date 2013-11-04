//
//  BackGroundClass.h
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackGroundClass : NSObject
typedef NS_ENUM(NSInteger, WorldType) {
    WorldTypeUniverse1,
    WorldTypeUniverse2,
    WorldTypeDesert,
    WorldTypeForest,
    WorldTypeNangoku,
    WorldTypeSnow
};

-(id)init;
-(id)init:(WorldType)_type width:(int)width height:(int)height;
-(void)doNext;
-(UIImageView *)getImageView1;
-(UIImageView *)getImageView2;
@end
