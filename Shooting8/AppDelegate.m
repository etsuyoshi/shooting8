//
//  AppDelegate.m
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "AppDelegate.h"
#import <AppSocially/AppSocially.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [AppSocially setAPIKey:@"7774ac78f4afd9934a1483eb5485e2d5"];//38abee1be738a828fecc1a56a79d4592"];
    
//    #warning Replace with YOUR APP's AppSociallyAPIKey and FacebookAppID
    [AppSocially setFacebookAppID:@"117100645022644"];
    
    
    
    // appearance
    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor],
                                 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                 UITextAttributeFont: [UIFont fontWithName:@"Futura-Medium" size:20.0f]};
    
    UIImage *barColorImage = [UIImage imageNamed:@"BarColor.png"];
    [[UINavigationBar appearance] setBackgroundImage:barColorImage
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if (version.floatValue < 7.0) {
        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    //電話がかかってきた時やSMSが来た時
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //ホームボタンが押された時
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"didEnterBackground"
                                                        object: nil
                                                      userInfo: nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //バックグランドから
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
