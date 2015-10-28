//
//  SCVideoPlayControlView.h
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "ITTXibView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>

/*
 15.7.21  新建视频播放类，只负责播放
 */

@protocol SCVideoPlayControlViewDelegate <NSObject>

- (void)videoPlayControlViewIsPrepareToPlay;
- (void)videoPlayControlViewIsFinishPlay;
- (void)videoPlayControlViewCurrentPlayState:(int)playState;
- (void)videoPlayControlViewCurrentLoadState:(int)loadState;
- (void)videoPlayControlViewCurrentPlayedTime:(CGFloat)playedTime PlayableTime:(CGFloat)playableTime TotalTime:(CGFloat)totalTime;

@end

@interface SCVideoPlayControlView : ITTXibView

@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) id<SCVideoPlayControlViewDelegate>delegate;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;

- (void)setUpMoviePlayerControllerWithPlayUrl:(NSString *)videoPlayUrl;

- (void)resetDataContainLastPlayedTime:(BOOL)containLastPlayedTime;

- (void)destorySelf;

- (void)removeAllObserver;

- (void)changeMoviePlayerPlayState;

- (void)adjustMoviePlayerControllerSize;

- (void)controlMoviePlayerStateIsPlay:(BOOL)isPlay;

- (void)setMoviePlayerPlayAtTime:(CGFloat)choosePlayTime;

@end
