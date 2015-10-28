//
//  SCVideoPlayTimeChooseHintView.h
//  StormChannel
//
//  Created by 王琦 on 15/7/23.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "ITTXibView.h"

/*
 15.7.23  新建选择视频播放进度时显示的view
 */

@interface SCVideoPlayTimeChooseHintView : ITTXibView

@property (assign, nonatomic) CGFloat totalTimeValue;
@property (assign, nonatomic) CGFloat playedTimeValue;
@property (assign, nonatomic) BOOL isSeekingBackward;

@end
