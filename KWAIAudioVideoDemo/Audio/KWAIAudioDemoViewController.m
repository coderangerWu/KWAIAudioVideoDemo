//
//  KWAIAudioDemoViewController.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "KWAIAudioDemoViewController.h"
#import "KWAIAudioController.h"
#import "KWAIAudioRecorderController.h"

@interface KWAIAudioDemoViewController ()

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) KWAIAudioController *musicPlayer;

@property (nonatomic, strong) KWAIAudioRecorderController *audioRecorder;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation KWAIAudioDemoViewController
- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Audio Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.slider.frame = CGRectMake(0, 0, 300, 20);
    self.slider.center = self.view.center;
    self.slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self.view addSubview:self.slider];
    
    self.playBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds)/2.0-80)/2.0, CGRectGetHeight(self.view.bounds)-80, 80, 40);
    [self.view addSubview:self.playBtn];
    
    self.recordBtn.frame = CGRectMake(CGRectGetWidth(self.view.bounds)/2.0+((CGRectGetWidth(self.view.bounds)/2.0-80)/2.0), CGRectGetHeight(self.view.bounds)-80, 80, 40);
    [self.view addSubview:self.recordBtn];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.musicPlayer play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if([self.musicPlayer isPlaying]) {
        [self.musicPlayer stop];
    }
    
    [self.displayLink setPaused:YES];
    [self.displayLink invalidate];
}

#pragma mark - Action
- (void)updateMeter:(CADisplayLink *)link
{
    if ([self.musicPlayer isPlaying]) {
        [self.musicPlayer updateMeters];
        self.slider.value = [self.musicPlayer averageValueForChannel:0];
    }
    else if ([self.audioRecorder isRecording]) {
        [self.audioRecorder updateMeters];
        self.slider.value = [self.audioRecorder averageValueForChannel:0];
    }
}

- (void)onPlayBtnClicked:(id)sender
{
    if (self.musicPlayer.isPlaying) {
        [self.musicPlayer pause];
        [self.displayLink setPaused:YES];
        [self.playBtn setTitle:@"播放音乐" forState:UIControlStateNormal];
    } else {
        [self.musicPlayer play];
        [self.displayLink setPaused:NO];
        [self.playBtn setTitle:@"暂停音乐" forState:UIControlStateNormal];
    }
}

- (void)onRecordBtnClicked:(id)sender
{
    if ([self.audioRecorder isRecording]) {
        [self.displayLink setPaused:YES];
        [self.audioRecorder stop];
        [sender setTitle:@"录音开始" forState:UIControlStateNormal];
    }else {
        [self.displayLink setPaused:NO];
        [self.audioRecorder record];
        [sender setTitle:@"录音结束" forState:UIControlStateNormal];
    }
}

#pragma mark - Lazy Load
- (KWAIAudioController *)musicPlayer
{
    if (_musicPlayer == nil) {
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp3"];
        KWAIAudioController *musicPlayer = [[KWAIAudioController alloc] initWithContentsOfURL:musicURL];
        _musicPlayer = musicPlayer;
    }
    return _musicPlayer;
}

- (KWAIAudioRecorderController *)audioRecorder
{
    if (_audioRecorder == nil) {
        NSURL *recordFileURL = [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"1.aac"]];
        KWAIAudioRecorderController *audioRecorder = [[KWAIAudioRecorderController alloc] initWithContentsOfURL:recordFileURL];
        _audioRecorder = audioRecorder;
    }
    return _audioRecorder;
}

- (UISlider *)slider
{
    if (_slider == nil) {
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
        slider.tintColor = [UIColor blueColor];
        slider.enabled = NO;
        slider.value = 0.0;
        slider.maximumValue = 1;
        slider.minimumValue = 0;
        slider.contentMode = UIViewContentModeScaleToFill;
        _slider = slider;
    }
    return _slider;
}

- (UIButton *)playBtn
{
    if (_playBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5.0;
        [btn setTitle:@"暂停音乐" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor blueColor];
        _playBtn = btn;
    }
    return _playBtn;
}

- (UIButton *)recordBtn
{
    if (_recordBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 5.0;
        [btn setTitle:@"开始录音" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onRecordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor blueColor];
        _recordBtn = btn;
    }
    return _recordBtn;
}

@end
