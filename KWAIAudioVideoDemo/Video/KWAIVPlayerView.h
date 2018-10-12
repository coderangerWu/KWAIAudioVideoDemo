//
//  KWAIVPlayerView.h
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/12.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWAIVPlayerView : UIView

//@property (nonatomic, strong) AVPlayer *player;

//@property (readonly) AVPlayerLayer *playerLayer;

@property (nonatomic, assign) float playbackVolume;
@property (nonatomic, readonly) float rate;

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)assetURL;

- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;

// 字幕
- (NSArray<AVMediaSelectionGroup *> *)mediaSelectionGroups;

- (void)selectMediaOption:(AVMediaSelectionOption *)mediaSelectionOption
    inMediaSelectionGroup:(AVMediaSelectionGroup *)mediaSelectionGroup;

- (NSTimeInterval)currentPlaybackTime;

- (void)setCurrentPlaybackTime:(NSTimeInterval)aCurrentPlaybackTime;

- (UIImage *)thumbnailImageAtCurrentTime;

@end

NS_ASSUME_NONNULL_END
