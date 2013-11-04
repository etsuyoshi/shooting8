//
//  GameClassViewController.h
//  ShootingTest
//
//  Created by 遠藤 豪 on 13/09/25.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>


@interface GameClassViewController : UIViewController{
    CFURLRef soundURL;
    SystemSoundID soundID;
    int enemyCount;//発生した敵の数
    int enemyDown;//倒した敵の数

}
//bgm
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;


//se
@property(readwrite) CFURLRef soundURL;
@property(readonly) SystemSoundID soundID;

@end
