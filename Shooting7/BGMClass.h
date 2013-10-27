//
//  BGMClass.h
//  Shooting6
//
//  Created by 遠藤 豪 on 13/10/22.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface BGMClass : NSObject{
    AVAudioPlayer *audioPlayer;
}

//@property (nonatomic, retain) AVAudioPlayer *audioPlayer;


-(void)play:(NSString *)playerName;
-(void)stop;
-(void)pause;
-(Boolean)getIsPlaying;
@end
