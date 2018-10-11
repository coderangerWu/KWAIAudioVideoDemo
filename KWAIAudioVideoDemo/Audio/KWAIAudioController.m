//
//  KWAIAudioController.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "KWAIAudioController.h"
#import "KWAIMeterTable.h"

@interface KWAIAudioController ()

@property (nonatomic, strong) KWAIMeterTable *meterTable;

@end

@implementation KWAIAudioController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithContentsOfURL:(NSURL *)url
{
    if (url && (self = [super init])) {
        NSError *error = nil;
        _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return nil;
        }
        
        _musicPlayer.volume = 0.5f;// 音量
        _musicPlayer.pan = 0.0f;// 立体声平移位置
        _musicPlayer.rate = 1.0f;// 播放速度
        _musicPlayer.numberOfLoops = -1;// 循环播放
        _musicPlayer.meteringEnabled = YES;// 开启电平测量开关
        [_musicPlayer prepareToPlay];
        
        _meterTable = [[KWAIMeterTable alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRouteChange:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:nil];
        
        return self;
    }
    
    return nil;
}

- (void)play
{
    NSError *error;
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"setCategory error: %@", [error localizedDescription]);
        return;
    }
    
    if (![[AVAudioSession sharedInstance] setActive:YES error:&error]) {
        NSLog(@"setActive error: %@", [error localizedDescription]);
        return;
    }
    
    if (![_musicPlayer isPlaying]) {
        [_musicPlayer play];
    }
}

- (BOOL)playAtTime:(NSTimeInterval)time
{
    return [_musicPlayer playAtTime:time];
}

- (void)pause
{
    [_musicPlayer pause];
}

- (void)stop
{
    if ([_musicPlayer isPlaying]) {
        [_musicPlayer stop];
    }
}

- (BOOL)isPlaying
{
    return [_musicPlayer isPlaying];
}

- (void)updateMeters
{
    [_musicPlayer updateMeters];
}

- (float)peakValueForChannel:(NSUInteger)channelNumber
{
    return [_meterTable valueForPower:[_musicPlayer peakPowerForChannel:channelNumber]];
}

- (float)averageValueForChannel:(NSUInteger)channelNumber
{
    return [_meterTable valueForPower:[_musicPlayer averagePowerForChannel:channelNumber]];
}

#pragma mark - Notification
- (void)handleInterruption:(NSNotification *)notice
{
    AVAudioSessionInterruptionType type = [notice.userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [_musicPlayer pause];
    }else if (type == AVAudioSessionInterruptionTypeEnded) {
        [_musicPlayer play];
    }
}

- (void)handleRouteChange:(NSNotification *)notice
{
    AVAudioSessionRouteChangeReason reason = [notice.userInfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *preRoute = notice.userInfo[AVAudioSessionRouteChangePreviousRouteKey];
        NSString *portType = [[preRoute.outputs firstObject] portType];
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            [_musicPlayer pause];
        }
    }
}

@end
