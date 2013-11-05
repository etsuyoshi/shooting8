//
//  BackGroundClass.h
//  Shooting8
//
//  Created by 遠藤 豪 on 2013/11/04.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WorldType) {
    WorldTypeUniverse1,
    WorldTypeUniverse2,
    WorldTypeDesert,
    WorldTypeForest,
    WorldTypeNangoku,
    WorldTypeSnow
};



@interface BackGroundClass : NSObject{
    
    int y_loc1;
    int y_loc2;
    int originalFrameSize;
    NSString *imageName;
    UIImageView *iv_background1;
    UIImageView *iv_background2;
}
@property(nonatomic) WorldType wType;

-(id)init;
-(id)init:(WorldType)_type width:(int)width height:(int)height;
-(void)startAnimation:(float)secs;
-(void)doNext;
-(UIImageView *)getImageView1;
-(UIImageView *)getImageView2;
@end
