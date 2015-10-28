//
//  SCVideoPlayFullScreenControlView.h
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "ITTXibView.h"

/*
 15.7.21  新建视频播放全屏控制类
 */

@protocol SCVideoPlayFullScreenControlViewDelegate <NSObject>

- (void)videoPlayFullScreenControlViewPlayButtonTapped;
- (void)videoPlayFullScreenControlViewReplayButtonTapped;
- (void)videoPlayFullScreenControlViewExitFullScreenButtonTapped;
- (void)videoPlayFullScreenControlViewChoosingTimeValue:(CGFloat)timeValue;
- (void)videoPlayFullScreenControlViewChoosePlayTimeValue:(CGFloat)timeValue;

@end

@interface SCVideoPlayFullScreenControlView : ITTXibView

@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL isShowing;
@property (strong, nonatomic) NSString *videoTitle;
@property (assign, nonatomic) id<SCVideoPlayFullScreenControlViewDelegate>delegate;

- (void)initSubviews;

- (void)videoPlayBegin;

- (void)videoPlayFinish;

- (void)resetDataContainLastPlayedTime:(BOOL)containLastPlayedTime;

- (void)setVideoPlayedTimeValue:(CGFloat)playedValue BufferedTimeValue:(CGFloat)bufferedValue TotalTimeValue:(CGFloat)totalValue;

- (void)setChoosePlayedTimeValue:(CGFloat)choosedTimeValue;

@end
