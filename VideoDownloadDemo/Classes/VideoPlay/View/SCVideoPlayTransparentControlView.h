//
//  SCVideoPlayTransparentControlView.h
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "ITTXibView.h"

/*
 15.7.21  新建视频播放透明控制类：控制横竖屏控制view的显示／隐藏，进度，音量，屏幕亮度等
 15.7.23  目前调整进度的规则是滑动整个屏幕的距离会快进或快退60s，修改totalSeekingValue值即可改变
 */

@protocol SCVideoPlayTransparentControlViewDelegate <NSObject>

- (void)videoPlayTransparentControlViewTouchEnded;
- (void)videoPlayTransparentControlViewChoosingTimeValue:(CGFloat)timeValue;
- (void)videoPlayTransparentControlViewChoosePlayTimeValue:(CGFloat)timeValue;

@end

@interface SCVideoPlayTransparentControlView : ITTXibView

@property (assign, nonatomic) BOOL ifCanMove;
@property (assign, nonatomic) CGFloat totalTimeValue;
@property (assign, nonatomic) CGFloat playedTimeValue;
@property (assign, nonatomic) CGFloat totalSeekingValue;

@property (assign, nonatomic) id<SCVideoPlayTransparentControlViewDelegate>delegate;

- (void)adjustSeekingHintViewPosition;

@end
