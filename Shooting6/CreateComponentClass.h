//
//  CreateComponentClass.h
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/15.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, ButtonType) {
    ButtonTypeDefault = 0,          // default
    ButtonTypeWithImage            // imageDefault
};

@interface CreateComponentClass : NSObject{
    
}


+(UIView *)createView;
+(UIView *)createView:(CGRect)rect;
+(UIView *)createView:(CGRect)rect
                color:(UIColor*)color
                alpha:(float)alpha
         cornerRaidus:(float)cornerRadius
          borderColor:(UIColor*)borderColor
          borderWidth:(float)borderWidth;


+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image;

+(UIButton *)createButton:(id)target
                 selector:(NSString *)selName;
+(UIButton *)createButtonWithType:(ButtonType)type
                             rect:(CGRect)rect
                            image:(NSString *)image
                           target:(id)target
                         selector:(NSString *)selName;

+(UIButton *)createQBButton:(ButtonType)type
                     rect:(CGRect)rect
                    image:(NSString *)image
                   target:(id)target
                 selector:(NSString *)selName;
@end
