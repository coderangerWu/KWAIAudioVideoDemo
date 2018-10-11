//
//  KWAIVideoDemoViewController.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "KWAIVideoDemoViewController.h"
#import "KWAIPlayer.h"

@interface KWAIVideoDemoViewController ()

@property (nonatomic, strong) KWAIPlayer *player;

@end

@implementation KWAIVideoDemoViewController

- (void)dealloc
{
    [self.player stop];
    self.player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Video Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
    self.player = [[KWAIPlayer alloc] initWithURL:fileURL];
    
    self.player.previewView.frame = self.view.bounds;
    [self.view addSubview:self.player.previewView];
    
    [self.player play];
}

@end
