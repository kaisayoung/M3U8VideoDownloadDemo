//
//  SCVideoPlayProgressControlView.h
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "ITTXibView.h"

/*
 15.7.21  新建视频播放进度控制类
 */

@protocol SCVideoPlayProgressControlViewDelegate <NSObject>

- (void)videoPlayProgressControlViewChoosingTimeValue:(CGFloat)timeValue;
- (void)videoPlayProgressControlViewChoosePlayTimeValue:(CGFloat)timeValue;

@end

@interface SCVideoPlayProgressControlView : ITTXibView

@property (assign, nonatomic) BOOL ifCanMove;
@property (assign, nonatomic) CGFloat totalTimeValue;
@property (assign, nonatomic) CGFloat playedTimeValue;
@property (assign, nonatomic) CGFloat playableTimeValue;

@property (assign, nonatomic) id<SCVideoPlayProgressControlViewDelegate>delegate;

- (void)resetData;

@end
