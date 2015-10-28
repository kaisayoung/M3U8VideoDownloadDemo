//
//  SCVideoPlayNormalScreenControlView.h
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "ITTXibView.h"

/*
 15.7.21  新建视频播放正常屏控制类
 */

@protocol SCVideoPlayNormalScreenControlViewDelegate <NSObject>

- (void)videoPlayNormalScreenControlViewExitButtonTapped;
- (void)videoPlayNormalScreenControlViewPlayButtonTapped;
- (void)videoPlayNormalScreenControlViewReplayButtonTapped;
- (void)videoPlayNormalScreenControlViewEnterFullScreenButtonTapped;
- (void)videoPlayNormalScreenControlViewChoosingTimeValue:(CGFloat)timeValue;
- (void)videoPlayNormalScreenControlViewChoosePlayTimeValue:(CGFloat)timeValue;

@end

@interface SCVideoPlayNormalScreenControlView : ITTXibView

@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL isListPlay;
@property (strong, nonatomic) NSString *videoTitle;
@property (assign, nonatomic) id<SCVideoPlayNormalScreenControlViewDelegate>delegate;

- (void)initSubviews;

- (void)videoPlayBegin;

- (void)videoPlayFinish;

- (void)resetDataContainLastPlayedTime:(BOOL)containLastPlayedTime;

- (void)setVideoPlayedTimeValue:(CGFloat)playedValue BufferedTimeValue:(CGFloat)bufferedValue TotalTimeValue:(CGFloat)totalValue;

- (void)setChoosePlayedTimeValue:(CGFloat)choosedTimeValue;

@end
