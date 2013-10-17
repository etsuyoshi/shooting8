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
+(UIView *)createView{
    CGRect rect = CGRectMake(10, 50, 300, 400);
    return [self createView:rect];
    
}

//standard2
+(UIView *)createView:(CGRect)rect{
    UIColor *color = [UIColor blackColor];
    float alpha = 0.5f;
    float cornerRadius = 10.0f;
    UIColor *borderColor = [UIColor lightGrayColor];
    float borderWidth = 2.0f;
    
    return [self createView:rect
                      color:color
                      alpha:alpha
               cornerRaidus:cornerRadius
                borderColor:borderColor
                borderWidth:borderWidth];
}


//manufact
+(UIView *)createView:(CGRect)rect
                color:(UIColor*)color
                alpha:(float)alpha
         cornerRaidus:(float)cornerRadius
          borderColor:(UIColor*)borderColor
          borderWidth:(float)borderWidth{
    
    
    UIView *view = [[UIView alloc]init];
    
    //            view.frame = self.view.bounds;//画面全体
    view.frame = rect;
    view.backgroundColor = color;
    view.alpha = alpha;
    
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


+(UIImageView *)createImageView:(CGRect)rect
                         image:(NSString *)image{
    
    if(image != nil){
        UIImageView *iv = [[UIImageView alloc]initWithFrame:rect];
        iv.image = [UIImage imageNamed:image];
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
        
        qbBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [qbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qbBtn setTitle:@"Get" forState:UIControlStateNormal];
        [qbBtn addTarget:target
                  action:NSSelectorFromString(selName)
    forControlEvents:UIControlEventTouchUpInside];
        return qbBtn;
    }

    
    return nil;
}


@end
