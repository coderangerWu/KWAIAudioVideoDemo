//
//  KWAIAudioController.h
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWAIAudioController : NSObject

@property (nonatomic, strong, readonly) AVAudioPlayer *musicPlayer;
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;

- (instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithContentsOfURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

- (void)play;
- (BOOL)playAtTime:(NSTimeInterval)time;
- (void)pause;
- (void)stop;

- (void)updateMeters;

- (float)peakValueForChannel:(NSUInteger)channelNumber;
- (float)averageValueForChannel:(NSUInteger)channelNumber;

@end

NS_ASSUME_NONNULL_END
