//
//  BGMClass.m
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/22.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "BGMClass.h"
#import <AVFoundation/AVFoundation.h>

@implementation BGMClass

-(void)play:(NSString *)playerName{
    //BGM START:時間送れ
    NSString *path = [[NSBundle mainBundle] pathForResource:playerName ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];

}

-(void)stop{
    [audioPlayer stop];
}

-(void)pause{
    [audioPlayer pause];
}

-(Boolean)getIsPlaying{
    return audioPlayer.playing;
}


@end
