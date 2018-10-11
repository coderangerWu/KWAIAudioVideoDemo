//
//  KWAIPlayer.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "KWAIPlayer.h"
#import "KWAIPlayerView.h"

static NSString *KWAIPlayerItemContext;

@interface KWAIPlayer ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVAsset *asset;
@end

@implementation KWAIPlayer

- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    self.playerItem = nil;
}

- (instancetype)initWithURL:(NSURL *)assetURL
{
    if (assetURL && (self = [super init])) {
        _asset = [AVAsset assetWithURL:assetURL];
        _previewView = [[KWAIPlayerView alloc] init];
        
        [self prepare];
    }
    
    return self;
}

- (void)prepare
{
    NSArray *requestedKeys = @[@"playable"];
    
    [self.asset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus status =
        [self.asset statusOfValueForKey:@"playable" error:&error];
        switch (status) {
            case AVKeyValueStatusLoaded:
                // Sucessfully loaded, continue processing
                [self didPrepareToPlayAsset:self.asset withKeys:requestedKeys];
                break;
            case AVKeyValueStatusFailed:
                // Examine NSError pointer to determine failure
                break;
            case AVKeyValueStatusCancelled:
                // Loading cancelled
                break;
            default:
                // Handle all other cases
                break;
        }
    }];
}

- (void)didPrepareToPlayAsset:(AVAsset *)asset withKeys:(NSArray *)requestedKeys
{
    NSArray *keys = @[@"tracks", @"duration", @"commonMetadata"];
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&KWAIPlayerItemContext];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    [(KWAIPlayerView *)self.previewView setPlayer:self.player];
}

#pragma mark - PublicMethod
- (void)play
{
    [self.player play];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)pause
{
    [self.player pause];
}

- (void)stop
{
    [self.player pause];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setVideoFillMode:(NSString *)fillMode
{
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[self.previewView layer];
    playerLayer.videoGravity = fillMode;
}

- (NSTimeInterval)currentPlaybackTime
{
    if (!self.player)
        return 0.0f;
    
    return CMTimeGetSeconds([self.player currentTime]);
}

- (void)setCurrentPlaybackTime:(NSTimeInterval)aCurrentPlaybackTime
{
    if (!self.player)
        return;
    
    [self.player seekToTime:CMTimeMakeWithSeconds(aCurrentPlaybackTime, NSEC_PER_SEC)
      completionHandler:^(BOOL finished) {
          if (!finished)
              return;
          
          dispatch_async(dispatch_get_main_queue(), ^{
              [self.player play];
          });
      }];
}

- (void)setPlaybackVolume:(float)playbackVolume
{
    _playbackVolume = playbackVolume;
    if (self.player != nil && self.player.volume != playbackVolume) {
        self.player.volume = playbackVolume;
    }
}

- (NSArray<AVMediaSelectionGroup *> *)mediaSelectionGroups
{
    NSMutableArray *mediaSelectionGroups = [NSMutableArray array];
    NSArray *mediaCharacteristics = [self.asset availableMediaCharacteristicsWithMediaSelectionOptions];
    for (NSString *mediaCharacteristic in mediaCharacteristics) {
        [mediaSelectionGroups addObject:[self.asset mediaSelectionGroupForMediaCharacteristic:mediaCharacteristic]];
    }
    return [mediaSelectionGroups copy];
}

- (void)selectMediaOption:(AVMediaSelectionOption *)mediaSelectionOption
    inMediaSelectionGroup:(AVMediaSelectionGroup *)mediaSelectionGroup
{
    [self.playerItem selectMediaOption:mediaSelectionOption inMediaSelectionGroup:mediaSelectionGroup];
}

- (UIImage *)thumbnailImageAtCurrentTime
{
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    NSError *error = nil;
    CMTime time = CMTimeMakeWithSeconds(self.currentPlaybackTime, 1);
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    return image;
}

#pragma mark - Observe
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (context == &KWAIPlayerItemContext) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"%@ : error:%@", @"AVPlayerItemStatusUnknown", [_playerItem.error localizedDescription]);
                break;
                
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"%@", @"AVPlayerItemStatusReadyToPlay");
                [self.player play];
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"%@ : error:%@", @"AVPlayerItemStatusFailed", [_playerItem.error localizedDescription]);
                break;
        }
    }
}

@end
