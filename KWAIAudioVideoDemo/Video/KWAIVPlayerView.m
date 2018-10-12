//
//  KWAIVPlayerView.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/12.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "KWAIVPlayerView.h"

static NSString *KWAIPlayerItemContext;

@interface KWAIVPlayerView ()

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation KWAIVPlayerView
// Override UIView method
+ (Class)layerClass {
    return [AVPlayerLayer class];
}

#pragma mark - Properties
- (AVPlayer *)player {
    return self.playerLayer.player;
}

- (void)setPlayer:(AVPlayer *)player {
    self.playerLayer.player = player;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (float)rate
{
    return [self player].rate;
}

#pragma mark - API
- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)assetURL
{
    if (assetURL && (self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor blackColor];
        
        _asset = [AVAsset assetWithURL:assetURL];
        
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
    
    // must called in main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset automaticallyLoadedAssetKeys:keys];
        
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&KWAIPlayerItemContext];
        
        AVPlayer *player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playerLayer.player = player;
    });
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

- (BOOL)isPlaying
{
    return _isPlaying;
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
    
    if ([keyPath isEqualToString:@"status"]) {
        
    } else if ([keyPath isEqualToString:@"rate"]) {
        if ([[change objectForKey:NSKeyValueChangeNewKey]integerValue]==0) {
            _isPlaying = NO;
        }else{
            _isPlaying = YES;
        }
    }
}
@end
