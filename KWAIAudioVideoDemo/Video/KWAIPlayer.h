//
//  KWAIPlayer.h
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWAIPlayer : NSObject

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, assign) float playbackVolume;

- (instancetype)initWithURL:(NSURL *)assetURL;

- (void)setVideoFillMode:(NSString *)fillMode;

- (void)play;
- (void)pause;
- (void)stop;

// 字幕
- (NSArray<AVMediaSelectionGroup *> *)mediaSelectionGroups;
- (void)selectMediaOption:(AVMediaSelectionOption *)mediaSelectionOption
    inMediaSelectionGroup:(AVMediaSelectionGroup *)mediaSelectionGroup;

- (NSTimeInterval)currentPlaybackTime;
- (void)setCurrentPlaybackTime:(NSTimeInterval)aCurrentPlaybackTime;

- (UIImage *)thumbnailImageAtCurrentTime;

@end

NS_ASSUME_NONNULL_END
