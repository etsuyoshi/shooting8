//
//  CreateComponentClass.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/15.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "CreateComponentClass.h"
#import "QBFlatButton.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@implementation CreateComponentClass

//standard1
+(UITextView *)createTextView:(CGRect)rect
                       text:(NSString *)text{
    
    return [self createTextView:(CGRect)rect
                           text:(NSString *)text
                           font:@"AmericanTypewriter-Bold"
                           size:14
                      textColor:[UIColor whiteColor]
                      backColor:[UIColor blackColor]
                     isEditable:NO];
}

//manufact
+(UITextView *)createTextView:(CGRect)rect
                         text:(NSString *)text
                         font:(NSString *)font
                         size:(int)size
                    textColor:(UIColor *)textColor
                    backColor:(UIColor *)backColor
                   isEditable:(Boolean)isEditable{
    UITextView *tv = [[UITextView alloc]initWithFrame:rect];
    [tv setFont:[UIFont fontWithName:font size:size]];
    tv.text = [NSString stringWithFormat:@"%@", text];
    tv.textColor = textColor;
    tv.backgroundColor = backColor;
    tv.editable = isEditable;
    return tv;
    
    
//    return nil;
}

//standard1
+(UIView *)createView{
    CGRect rect = CGRectMake(10, 50, 300, 400);
    return [self createView:rect];
    
}

//standard2
+(UIView *)createView:(CGRect)rect{
    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    float cornerRadius = 10.0f;
    UIColor *borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    float borderWidth = 2.0f;
    
    return [self createView:rect
                      color:color
               cornerRaidus:cornerRadius
                borderColor:borderColor
                borderWidth:borderWidth];
}

//manufact
+(UIView *)createView:(CGRect)rect
                color:(UIColor*)color
         cornerRaidus:(float)cornerRadius
          borderColor:(UIColor*)borderColor
          borderWidth:(float)borderWidth{
    
    
    UIView *view = [[UIView alloc]init];
    
    //            view.frame = self.view.bounds;//画面全体
    view.frame = rect;
    
    view.backgroundColor = color;
//    view.alpha = alpha;
    
    //丸角にする
    [[view layer] setCornerRadius:cornerRadius];
    [view setClipsToBounds:YES];
    
    //UIViewに枠線を追加する
    [[view layer] setBorderColor:[borderColor CGColor]];
    [[view layer] setBorderWidth:borderWidth];
    
    //    [self.view bringSubviewToFront:view];
    //    [self.view addSubview:view];
    return view;
}

//manufact2:tapイベントを付ける(フレームなし)
+(UIView *)createViewNoFrame:(CGRect)rect
                       color:(UIColor *)color
                         tag:(int)tag
                      target:(id)target
                    selector:(NSString *)selName{
//    UIView *v = [self createView:rect];
    UIView *v = [[UIView alloc]initWithFrame:rect];
    [v setBackgroundColor:color];
    v.tag = tag;
    v.userInteractionEnabled = YES;
    //NSSelectorFromString(selName)
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target
                                                                   action:NSSelectorFromString(selName)]];
    return v;
}
//manufact3:tapイベントを付ける(フレームあり)
+(UIView *)createViewWithFrame:(CGRect)rect
                       color:(UIColor *)color
                         tag:(int)tag
                      target:(id)target
                    selector:(NSString *)selName{
    
    float cornerRadius = 10.0f;
    UIColor *borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    float borderWidth = 2.0f;
    
    UIView *v = [self createView:rect
                           color:color
                    cornerRaidus:cornerRadius
                     borderColor:borderColor
                     borderWidth:borderWidth];
    v.tag = tag;
    v.userInteractionEnabled = YES;
    [v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target
                                                                   action:NSSelectorFromString(selName)]];
    return v;
}




+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image{
    
    if(image != nil){
        UIImageView *iv = [[UIImageView alloc]initWithFrame:rect];
        iv.image = [UIImage imageNamed:image];
        return iv;
    }
    
    return nil;
}

+(UIImageView *)createImageView:(CGRect)rect
                          image:(NSString *)image
                            tag:(int)tag
                         target:(id)target
                       selector:(NSString *)selName{
    if(image != nil){
        UIImageView *iv = [self createImageView:rect
                                          image:image];
        iv.tag = tag;
        iv.userInteractionEnabled = YES;
        //NSSelectorFromString(selName)
        [iv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:target
                                                                        action:NSSelectorFromString(selName)]];
        return iv;
    }
    
    return nil;
}


//standard
+(UIButton *)createButton:(id)target
                 selector:(NSString *)selName{
    int btWidth = 100;
    int btHeight = 40;
    
    return [self createButtonWithType:ButtonTypeDefault
                                 rect:CGRectMake(320/2-btWidth/2, 480/2-btHeight/2, btWidth, btHeight)//center
                                image:nil
                               target:target
                             selector:selName];
//    return nil;
}

//manufact
+(UIButton *)createButtonWithType:(ButtonType)buttonType
                             rect:(CGRect)rect
                            image:(NSString *)image
                           target:(id)target
                         selector:(NSString *)selName{
    
    
    if (buttonType == ButtonTypeDefault) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:rect];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentMode = UIViewContentModeScaleToFill;
        [button setTitle:@""
                forState:UIControlStateNormal];
        [button addTarget:target
                   action:NSSelectorFromString(selName)
         forControlEvents:UIControlEventTouchUpInside];
        return button;
    }else if(buttonType == ButtonTypeWithImage){
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentMode = UIViewContentModeScaleToFill;
        [button addTarget:target
                   action:NSSelectorFromString(selName)
         forControlEvents:UIControlEventTouchUpInside];
        UIImage *img = [UIImage imageNamed:image];
        [button setImage:img forState:UIControlStateNormal];
        return button;
        
    }
    
    return nil;
}


//manufacture
+(UIButton *)createQBButton:(ButtonType)type
                       rect:(CGRect)rect
                      image:(NSString *)image
                      title:(NSString *)title
                     target:(id)target
                   selector:(NSString *)selName{
    
    if (type == ButtonTypeDefault) {
        QBFlatButton *qbBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        qbBtn.frame = rect;
//        qbBtn.faceColor = [UIColor colorWithRed:154.0/255.0 green:255.0/255.0 blue:154.0/255.0 alpha:1.0];//palegreen 1
//        qbBtn.faceColor = [UIColor colorWithRed:0.0/255.0 green:250.0/255.0 blue:154.0/255.0 alpha:1.0];//mediumspringgreen
//        qbBtn.sideColor = [UIColor colorWithRed:0.0/255.0 green:205.0/255.0 blue:102.0/255.0 alpha:1.0];//springgreen 2
        qbBtn.faceColor = [UIColor colorWithRed:0.333 green:0.631 blue:0.851 alpha:1.0];//default
        qbBtn.sideColor = [UIColor colorWithRed:0.310 green:0.498 blue:0.702 alpha:1.0];//default
        qbBtn.radius = 8.0;
        qbBtn.margin = 4.0;
        qbBtn.depth = 3.0;
//        [qbBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        qbBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [qbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qbBtn setTitle:title forState:UIControlStateNormal];
        [qbBtn addTarget:target
                  action:NSSelectorFromString(selName)
    forControlEvents:UIControlEventTouchUpInside];
        return qbBtn;
    }
    
    if (type == ButtonTypeWithImage) {
        QBFlatButton *qbBtn = [QBFlatButton buttonWithType:UIButtonTypeCustom];
        qbBtn.frame = rect;
        //        qbBtn.faceColor = [UIColor colorWithRed:154.0/255.0 green:255.0/255.0 blue:154.0/255.0 alpha:1.0];//palegreen 1
        //        qbBtn.faceColor = [UIColor colorWithRed:0.0/255.0 green:250.0/255.0 blue:154.0/255.0 alpha:1.0];//mediumspringgreen
        //        qbBtn.sideColor = [UIColor colorWithRed:0.0/255.0 green:205.0/255.0 blue:102.0/255.0 alpha:1.0];//springgreen 2
        qbBtn.faceColor = [UIColor colorWithRed:0.333 green:0.631 blue:0.851 alpha:1.0];//default
        qbBtn.sideColor = [UIColor colorWithRed:0.310 green:0.498 blue:0.702 alpha:1.0];//default
        qbBtn.radius = 8.0;
        qbBtn.margin = 4.0;
        qbBtn.depth = 3.0;
        [qbBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        qbBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [qbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qbBtn setTitle:title forState:UIControlStateNormal];
        [qbBtn addTarget:target
                  action:NSSelectorFromString(selName)
        forControlEvents:UIControlEventTouchUpInside];
        return qbBtn;
    }

    
    return nil;
}

+(UIView *)createSlideShow:(CGRect)rect
                 imageFile:(NSArray *)imageArray
                    target:(id)target
                 selector1:(NSString *)selector1
                 selector2:(NSString *)selector2{
    
    int imageHeight = 300;
    int imageWidth = 300;
    int imageMarginHorizon = 10;
    int amountOfImage = [imageArray count];
    
    
    
    UIView *superView = [self createViewNoFrame:rect
                                          color:[UIColor clearColor]
                                            tag:9999//closeScrollに渡しているので不要
                                         target:target
                                       selector:selector1 ];//NSSelectorFromString(selector1)];//@"closeView:"];
    //            UIView *superView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    CGRect uv_rect = CGRectMake(rect.origin.x,
                                rect.origin.y,
                                rect.size.width,
                                rect.size.height - 80);
    
    //            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:uv_rect];
    sv.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];//こうすれば子どものalpha値は上書きされない
    
    UIView *uvOnScroll = [[UIView alloc] initWithFrame:CGRectMake(uv_rect.origin.x,
                                                                  uv_rect.origin.y,
                                                                  imageMarginHorizon + amountOfImage * (imageWidth + imageMarginHorizon),
                                                                  uv_rect.size.height)];
    [uvOnScroll setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
    sv.contentSize = uvOnScroll.bounds.size;
    //uvにタップリスナーを付けて、画像以外がタップされたら閉じる(selfを渡してremovefromsuperview?)=>できない
    //xボタンを付けるuiviewを付けるしかないか。。
    
    //http://qiita.com/tatsuof0126/items/46a41a897df2cd2684d4
    
    
    for(int numImage = 0; numImage < amountOfImage; numImage++){
        //imageViewには、タグ付けとtarget設定ができないので
        CGRect imageRect = CGRectMake(imageMarginHorizon + numImage * (imageWidth + imageMarginHorizon),
                                      -30, imageWidth, imageHeight);
        //                UIButton *imageButton = [CreateComponentClass createButtonWithType:ButtonTypeWithImage
        //                                                                              rect:imageRect
        //                                                                             image:@"close.png"
        //                                                                            target:self
        //                                                                          selector:@"imageTapped"];
        UIView *frameView = [self createView:imageRect];//imageのframe
        [frameView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];
        [uvOnScroll addSubview:frameView];
        UIImageView *imageView = [self createImageView:imageRect
                                                 image:[imageArray objectAtIndex:numImage]
                                                   tag:numImage
                                                target:target
                                              selector:selector2];
        [uvOnScroll addSubview:imageView];
        //                _iv addTarget
        //                [_iv addTarget:self action:@selector(pushed_button:) forControlEvents:UIControlEventTouchUpInside];
        //タップリスナーを追加してタップされたらダイアログで購入確認。
        
        
        
        
    }
    [sv addSubview:uvOnScroll];
    [superView addSubview:sv];
    return superView;

}

@end
