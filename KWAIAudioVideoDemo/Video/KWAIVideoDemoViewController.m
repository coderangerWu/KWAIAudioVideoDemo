//
//  KWAIVideoDemoViewController.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "KWAIVideoDemoViewController.h"
#import "KWAIVPlayerView.h"

@interface KWAIVideoDemoViewController ()

@property (nonatomic, strong) KWAIVPlayerView *vPlayer;

@end

@implementation KWAIVideoDemoViewController

- (void)dealloc
{
    [self.vPlayer stop];
    self.vPlayer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Video Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.vPlayer.frame = self.view.bounds;
    [self.view addSubview:self.vPlayer];
//    [self.view.layer addSublayer:self.vPlayer.playerLayer];
    
    [self.vPlayer play];
}

-(KWAIVPlayerView *)vPlayer
{
    if (_vPlayer == nil) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
        KWAIVPlayerView *vPlayer = [[KWAIVPlayerView alloc] initWithFrame:CGRectZero url:fileURL];
        
        UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScreenClicked:)];
        [guesture setNumberOfTapsRequired:1];
        [vPlayer addGestureRecognizer:guesture];
        
        _vPlayer = vPlayer;
    }
    return _vPlayer;
}

- (void)onScreenClicked:(UIGestureRecognizer *)guesture
{
    if ([self.vPlayer rate]>0) {
        [self.vPlayer pause];
    } else {
        [self.vPlayer play];
    }
}

@end
