//
//  SCVideoPlayManageView.h
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "ITTXibView.h"
#import "SCVideoPlayControlView.h"

/*
 15.7.21  新建视频播放管理类，外界只需引用这一个类
          首先封装成一个简单的可横竖屏切换的播放器类
 15.7.22  主流播放器比较：
          1 关于横竖屏切换方式：
          腾讯视频，爱奇艺视频，搜狐视频是一种，
          乐视视频，优酷视频，土豆视频是另一种。
          2 关于横竖屏切换时控制view是否显示：
          腾讯视频，搜狐视频和乐视视频都是先显示，过几s自动隐藏
          优酷视频是横竖屏控制view状态保持一致，不依切换而改变
          土豆视频是竖屏时默认隐藏，横屏时显示
          爱奇艺视频都是隐藏。
          3 关于进度显示条选择进度不拖动只点击一下：
          腾讯视频，搜狐视频，优酷视频，土豆视频不可选择
          爱奇艺视频，乐视视频可选择
          4 关于选择播放进度同时横竖屏切换：
          腾讯视频，乐视视频在选择进度的同时切换横竖屏则选择失效或者被取消
          爱奇艺视频，搜狐视频，优酷视频，土豆视频依然有效。
 15.7.23  横竖屏功能已大概实现，增加loadingview
 15.7.24  新增控制字段isListPlay，若为YES，则为列表播放，隐藏竖屏控制view的topview
 */

@protocol SCVideoPlayManageViewDelegate <NSObject>

- (void)videoPlayManageViewVideoBeginPlay;
- (void)videoPlayManageViewVideoFinishPlay;
- (void)videoPlayManageViewBackButtonTapped;
- (void)videoPlayManageViewReplayButtonTapped;
- (void)videoPlayManageViewExitFullScreenButtonTapped;
- (void)videoPlayManageViewEnterFullScreenButtonTapped;

@end

@interface SCVideoPlayManageView : ITTXibView

@property (assign, nonatomic) BOOL isListPlay;
@property (assign, nonatomic) NSInteger enterInFullScreenWayType;
@property (assign, nonatomic) id<SCVideoPlayManageViewDelegate>delegate;
@property (strong, nonatomic) SCVideoPlayControlView *videoPlayControlView;

- (void)beginInitSubviews;

- (void)resetData;

- (void)destorySelf;

- (void)enterInFullScreen;
- (void)exitFromFullScreen;

- (void)addTestDataWithVideoTitle:(NSString *)title Url:(NSString *)url;

@end






