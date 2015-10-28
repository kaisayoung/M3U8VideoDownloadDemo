//
//  SCVideoPlayManageView.m
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayManageView.h"
#import "SCVideoPlayNormalScreenControlView.h"
#import "SCVideoPlayFullScreenControlView.h"
#import "HYCircleLoadingView.h"

@interface SCVideoPlayManageView ()<SCVideoPlayControlViewDelegate,SCVideoPlayNormalScreenControlViewDelegate,SCVideoPlayFullScreenControlViewDelegate>

@property (strong, nonatomic) SCVideoPlayFullScreenControlView *fullScreenControlView;
@property (strong, nonatomic) SCVideoPlayNormalScreenControlView *normalScreenControlView;
@property (strong, nonatomic) HYCircleLoadingView *loadingView;

@end

@implementation SCVideoPlayManageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    _enterInFullScreenWayType = 0;
}

- (void)initVideoPlayControlView
{
    if(!_videoPlayControlView){
        _videoPlayControlView = [SCVideoPlayControlView loadFromXib];
        _videoPlayControlView.delegate = self;
        _videoPlayControlView.frame = self.bounds;
        [self addSubview:self.videoPlayControlView];
    }
}

- (void)initVideoPlayFullScreenControlView
{
    if(!_fullScreenControlView){
        _fullScreenControlView = [SCVideoPlayFullScreenControlView loadFromXib];
        _fullScreenControlView.delegate = self;
        if(SCREEN_WIDTH>SCREEN_HEIGHT){
            _fullScreenControlView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        else{
            _fullScreenControlView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        }
        _fullScreenControlView.hidden = YES;
        _fullScreenControlView.isShowing = NO;
        [self addSubview:self.fullScreenControlView];
        [_fullScreenControlView initSubviews];
    }
}

- (void)initVideoPlayNormalScreenControlView
{
    if(!_normalScreenControlView){
        _normalScreenControlView = [SCVideoPlayNormalScreenControlView loadFromXib];
        _normalScreenControlView.delegate = self;
        _normalScreenControlView.frame = self.bounds;
        _normalScreenControlView.isListPlay = _isListPlay;
        [self addSubview:self.normalScreenControlView];
        [_normalScreenControlView initSubviews];
    }
}

- (void)initLoadingView
{
    if(!_loadingView){
        _loadingView = [[HYCircleLoadingView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _loadingView.loadingType = 1;
        _loadingView.clipsToBounds = YES;
        _loadingView.centerX = self.width/2;
        _loadingView.centerY = self.height/2;
        [self addSubview:_loadingView];
    }
}

- (void)beginInitSubviews
{
    [self initVideoPlayControlView];
    [self initVideoPlayFullScreenControlView];
    [self initVideoPlayNormalScreenControlView];
    [self initLoadingView];
    [self loadingViewIsShowing:YES];
}

- (void)resetData
{
    [_videoPlayControlView resetDataContainLastPlayedTime:YES];
    [_fullScreenControlView resetDataContainLastPlayedTime:YES];
    [_normalScreenControlView resetDataContainLastPlayedTime:YES];
    [self loadingViewIsShowing:YES];
}

- (void)destorySelf
{
    [_videoPlayControlView destorySelf];
    _videoPlayControlView.delegate = nil;
    _videoPlayControlView = nil;
}

- (void)enterInFullScreen
{
    _fullScreenControlView.hidden = NO;
    _normalScreenControlView.hidden = YES;
    _fullScreenControlView.isShowing = YES;
    _videoPlayControlView.frame = self.bounds;
    _fullScreenControlView.frame = self.bounds;
    [_videoPlayControlView adjustMoviePlayerControllerSize];
    [self adjustLoadingViewPositionIfEnterIn:YES];
}

- (void)exitFromFullScreen
{
    _fullScreenControlView.hidden = YES;
    _normalScreenControlView.hidden = NO;
    _fullScreenControlView.isShowing = NO;
    _videoPlayControlView.frame = self.bounds;
    _fullScreenControlView.frame = self.bounds;
    [_videoPlayControlView adjustMoviePlayerControllerSize];
    [self adjustLoadingViewPositionIfEnterIn:NO];
}

- (void)adjustLoadingViewPositionIfEnterIn:(BOOL)isEnterIn
{
    [UIView animateWithDuration:0.3 animations:^{
        if(isEnterIn && _enterInFullScreenWayType!=0){
            _loadingView.centerX = self.height/2;
            _loadingView.centerY = self.width/2;
        }
        else{
            _loadingView.centerX = self.width/2;
            _loadingView.centerY = self.height/2;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)loadingViewIsShowing:(BOOL)isShowing
{
    _loadingView.hidden = !isShowing;
    if(isShowing){
        [_loadingView startAnimation];
    }
    else{
        [_loadingView stopAnimation];
    }
}

- (void)addTestDataWithVideoTitle:(NSString *)title Url:(NSString *)url
{
    NSLog(@"begin loading");
    _fullScreenControlView.videoTitle = title;
    _normalScreenControlView.videoTitle = title;
    [_videoPlayControlView setUpMoviePlayerControllerWithPlayUrl:url];
}

#pragma mark --- SCVideoPlayControlViewDelegate ---

- (void)videoPlayControlViewIsPrepareToPlay;
{
    NSLog(@"stop loading & begin play");
    [_fullScreenControlView videoPlayBegin];
    [_normalScreenControlView videoPlayBegin];
    [self loadingViewIsShowing:NO];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayManageViewVideoBeginPlay)]){
        [_delegate videoPlayManageViewVideoBeginPlay];
    }
}

- (void)videoPlayControlViewIsFinishPlay
{
    NSLog(@"Play finish hahaha!!!");
    [_fullScreenControlView videoPlayFinish];
    [_normalScreenControlView videoPlayFinish];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayManageViewVideoFinishPlay)]){
        [_delegate videoPlayManageViewVideoFinishPlay];
    }
}

- (void)videoPlayControlViewCurrentPlayState:(int)playState
{
    if(playState==MPMoviePlaybackStatePlaying){
        _fullScreenControlView.isPlaying = YES;
        _normalScreenControlView.isPlaying = YES;
    }
    else{
        _fullScreenControlView.isPlaying = NO;
        _normalScreenControlView.isPlaying = NO;
    }
}

- (void)videoPlayControlViewCurrentLoadState:(int)loadState
{
    
}

- (void)videoPlayControlViewCurrentPlayedTime:(CGFloat)playedTime PlayableTime:(CGFloat)playableTime TotalTime:(CGFloat)totalTime
{
    [_fullScreenControlView setVideoPlayedTimeValue:playedTime BufferedTimeValue:playableTime TotalTimeValue:totalTime];
    [_normalScreenControlView setVideoPlayedTimeValue:playedTime BufferedTimeValue:playableTime TotalTimeValue:totalTime];
}

#pragma mark --- SCVideoPlayNormalScreenControlViewDelegate ---

- (void)videoPlayNormalScreenControlViewExitButtonTapped
{
    [self destorySelf];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayManageViewBackButtonTapped)]){
        [_delegate videoPlayManageViewBackButtonTapped];
    }
}

- (void)videoPlayNormalScreenControlViewPlayButtonTapped
{
    [_videoPlayControlView changeMoviePlayerPlayState];
}

- (void)videoPlayNormalScreenControlViewReplayButtonTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayManageViewReplayButtonTapped)]){
        [_delegate videoPlayManageViewReplayButtonTapped];
    }
}

- (void)videoPlayNormalScreenControlViewEnterFullScreenButtonTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayManageViewEnterFullScreenButtonTapped)]){
        [_delegate videoPlayManageViewEnterFullScreenButtonTapped];
    }
}

- (void)videoPlayNormalScreenControlViewChoosingTimeValue:(CGFloat)timeValue
{
    [_videoPlayControlView controlMoviePlayerStateIsPlay:NO];
}

- (void)videoPlayNormalScreenControlViewChoosePlayTimeValue:(CGFloat)timeValue
{
    [_videoPlayControlView setMoviePlayerPlayAtTime:timeValue];
}

#pragma mark --- SCVideoPlayFullScreenControlViewDelegate ---

- (void)videoPlayFullScreenControlViewPlayButtonTapped
{
    [_videoPlayControlView changeMoviePlayerPlayState];
}

- (void)videoPlayFullScreenControlViewReplayButtonTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayManageViewReplayButtonTapped)]){
        [_delegate videoPlayManageViewReplayButtonTapped];
    }
}

- (void)videoPlayFullScreenControlViewExitFullScreenButtonTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayManageViewExitFullScreenButtonTapped)]){
        [_delegate videoPlayManageViewExitFullScreenButtonTapped];
    }
}

- (void)videoPlayFullScreenControlViewChoosingTimeValue:(CGFloat)timeValue
{
    [_videoPlayControlView controlMoviePlayerStateIsPlay:NO];
}

- (void)videoPlayFullScreenControlViewChoosePlayTimeValue:(CGFloat)timeValue
{
    [_videoPlayControlView setMoviePlayerPlayAtTime:timeValue];
}

@end








