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
#import "BackGroundClass2.h"


@interface GameClassViewController : UIViewController{
    CFURLRef sound_hit_URL;
    SystemSoundID sound_hit_ID;
    int enemyCount;//発生した敵の数
    int enemyDown;//倒した敵の数
    WorldType worldType;

}
//bgm
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;


//se
@property(readwrite) CFURLRef sound_hit_URL;
@property(readonly) SystemSoundID sound_hit_ID;

@end
