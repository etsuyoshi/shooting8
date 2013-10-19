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

+(UITextView *)createTextView:(CGRect)rect
                       text:(NSString *)text;
+(UITextView *)createTextView:(CGRect)rect
                         text:(NSString *)text
                         font:(NSString *)font
                         size:(int)size
                    textColor:(UIColor *)textColor
                    backColor:(UIColor *)backColor
                   isEditable:(Boolean)isEditable;



+(UIView *)createView;
+(UIView *)createView:(CGRect)rect;
+(UIView *)createView:(CGRect)rect
                color:(UIColor*)color
         cornerRaidus:(float)cornerRadius
          borderColor:(UIColor*)borderColor
          borderWidth:(float)borderWidth;
//フレームなしでタップイベント(フレームありタップイベント付きは必要に応じて作る予定)
+(UIView *)createViewNoFrame:(CGRect)rect
                       color:(UIColor *)color
                         tag:(int)tag
                      target:(id)target
                    selector:(NSString *)selName;

//タッチイベントを付けたimageview:http://php6.jp/iphone/2011/11/11/uilabel%E3%82%84uiimageview%E3%81%8C%E5%BF%9C%E7%AD%94%E3%81%97%E3%81%AA%E3%81%84/
+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image
                            tag:(int)tag
                         target:(id)target
                       selector:(NSString *)selName;

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
                      title:(NSString *)title
                   target:(id)target
                 selector:(NSString *)selName;


+(UIView *)createSlideShow:(CGRect)rect
                 imageFile:(NSArray *)fileArray
                    target:(id)target
                 selector1:(NSString *)selector1
                 selector2:(NSString *)selector2;
@end
