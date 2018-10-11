//
//  KWAIPlayerView.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "KWAIPlayerView.h"

@implementation KWAIPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self setBackgroundColor:[UIColor blackColor]];
    }
    
    return self;
}

- (void)setPlayer:(AVPlayer *)player
{
    if (!player) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [(AVPlayerLayer *)[self layer] setPlayer:player];
    });
}

@end
