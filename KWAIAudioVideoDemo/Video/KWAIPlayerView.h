//
//  KWAIPlayerView.h
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KWAIPlayerView : UIView

- (instancetype)init;

- (void)setPlayer:(AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
