//
//  KWAIAudioRecorderController.h
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWAIAudioRecorderController : NSObject<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) void(^finishCallback)(BOOL success, NSError * _Nullable error);
@property(readonly, getter=isRecording) BOOL recording;

- (instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithContentsOfURL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

- (BOOL)record;
- (BOOL)recordAtTime:(NSTimeInterval)time;
- (BOOL)recordForDuration:(NSTimeInterval) duration;
- (BOOL)recordAtTime:(NSTimeInterval)time forDuration:(NSTimeInterval) duration;

- (void)pause;
- (void)stop;

- (BOOL)deleteRecording;

- (void)updateMeters;

- (float)peakValueForChannel:(NSUInteger)channelNumber;
- (float)averageValueForChannel:(NSUInteger)channelNumber;

@end

NS_ASSUME_NONNULL_END
